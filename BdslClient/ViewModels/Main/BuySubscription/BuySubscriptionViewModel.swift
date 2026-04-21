//
//  BuySubscriptionViewModel.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 21.04.2026.
//

import Models
import OSLog
import Services
import SwiftUI

@MainActor
@Observable
final class BuySubscriptionViewModel {
    private let logger = Logger.forCategory(String(describing: BuySubscriptionViewModel.self))
    private let subscriptionsService: SubscriptionsService
    private let appState: AppState

    private(set) var availableActivities: [ActivitySubscription] = []
    private(set) var availableCourses: [CourseSubscription] = []
    private(set) var settings: SubscriptionSettings?

    var selectedActivityIds: Set<String> = []
    var selectedCourseIds: Set<String> = []
    var isUnlim = false

    var isLoading = false
    var isInitialized = false
    var localizedError: LocalizedStringResource?

    var isOrdering = false
    var invoiceUrl: URL?
    var orderError: LocalizedStringResource?

    var isShowingInvoice: Bool = false {
        didSet { if !isShowingInvoice { invoiceUrl = nil } }
    }

    var isShowingOrderError: Bool = false {
        didSet { if !isShowingOrderError { orderError = nil } }
    }

    init(subscriptionsService: SubscriptionsService, appState: AppState) {
        self.subscriptionsService = subscriptionsService
        self.appState = appState
    }

    // MARK: - Load

    func load() async {
        guard appState.isNetworkAvailable else {
            if !isInitialized {
                localizedError = .noInternetConnection
            }
            return
        }

        isLoading = true
        defer {
            isLoading = false
            isInitialized = true
        }

        do {
            localizedError = nil
            async let subscriptionsTask = subscriptionsService.fetchAvailableSubscriptions(forceReload: false)
            async let settingsTask = subscriptionsService.fetchSettings()

            let (activities, courses) = try await subscriptionsTask
            settings = try await settingsTask
            availableActivities = activities
            availableCourses = courses
        } catch TaskError.timeout {
            logger.warning("Timeout loading subscription data")
            localizedError = .theRequestTimedOut
        } catch {
            logger.warning("Failed to load subscription data: \(error)")
        }
    }

    // MARK: - Selection

    func toggleUnlim() {
        withAnimation {
            isUnlim.toggle()
            if isUnlim {
                selectedActivityIds = Set(availableActivities.map(\.id))
            } else {
                selectedActivityIds = []
            }
        }
    }

    func toggleActivity(_ id: String) {
        withAnimation {
            if isUnlim {
                // Unlim is active — tapping an item keeps only that one selected
                isUnlim = false
                selectedActivityIds = [id]
            } else if selectedActivityIds.contains(id) {
                selectedActivityIds.remove(id)
            } else {
                selectedActivityIds.insert(id)
                autoSelectUnlimIfNeeded()
            }
        }
    }

    private func autoSelectUnlimIfNeeded() {
        guard let settings else { return }
        let totalHours = selectedActivityIds.count * settings.subscriptionPricesHoursPerActivity
        if totalHours >= settings.subscriptionPricesUnlimStartsFrom {
            isUnlim = true
            selectedActivityIds = Set(availableActivities.map(\.id))
        }
    }

    func toggleCourse(_ id: String) {
        withAnimation {
            if selectedCourseIds.contains(id) {
                selectedCourseIds.remove(id)
            } else {
                selectedCourseIds.insert(id)
            }
        }
    }

    // MARK: - Display Data

    private static let stylePlaceholders: [ActivitySubscription] = (0 ..< 4).map { _ in
        ActivitySubscription(activity: .previewValue(), title: "Loading...")
    }

    private static let coursePlaceholders: [CourseSubscription] = (0 ..< 3).map { _ in
        CourseSubscription(activity: .previewValue(), subscription: .placeholder(), title: "Loading...")
    }

    var displayedStyles: [ActivitySubscription] {
        isInitialized ? availableActivities : Self.stylePlaceholders
    }

    var displayedCourses: [CourseSubscription] {
        isInitialized ? availableCourses : Self.coursePlaceholders
    }

    var showCoursesSection: Bool {
        !isInitialized || !availableCourses.isEmpty
    }

    // MARK: - Price

    var hasSelection: Bool {
        !selectedActivityIds.isEmpty || !selectedCourseIds.isEmpty || isUnlim
    }

    var calculatedPrice: Int {
        guard let settings, hasSelection else { return 0 }

        let selectedCourses = availableCourses.filter { selectedCourseIds.contains($0.id) }
        let standaloneCourses = selectedCourses.filter { $0.subscription.standalone }
        let nonStandaloneCourses = selectedCourses.filter { !$0.subscription.standalone }
        let standalonePrices = standaloneCourses.compactMap(\.subscription.regularPrice).reduce(0, +)

        // Unlim: base capped at PU hours, standalone courses added on top
        if isUnlim {
            let unlimPrice = settings.subscriptionPricesBase
                + settings.subscriptionPricesSteps
                * settings.subscriptionPricesUnlimStartsFrom
                / settings.subscriptionPricesHoursPerStep
            return unlimPrice + standalonePrices
        }

        let n = selectedActivityIds.count + nonStandaloneCourses.count

        // Only standalone courses selected — base is not applied
        guard n > 0 else {
            return standalonePrices
        }

        // Cap hours at the unlim threshold so price never exceeds unlim
        let totalHours = n * settings.subscriptionPricesHoursPerActivity
        let cappedHours = min(totalHours, settings.subscriptionPricesUnlimStartsFrom)

        let subscriptionPrice = settings.subscriptionPricesBase
            + settings.subscriptionPricesSteps
            * cappedHours
            / settings.subscriptionPricesHoursPerStep
        return subscriptionPrice + standalonePrices
    }

    // MARK: - Order

    func requestOrder() async {
        guard let userId = resolveUserId(), hasSelection else { return }

        isOrdering = true
        defer { isOrdering = false }

        do {
            orderError = nil
            let selectedActivities = availableActivities.filter { selectedActivityIds.contains($0.id) }
            let selectedCourses = availableCourses.filter { selectedCourseIds.contains($0.id) }

            let response = try await subscriptionsService.requestOrder(
                userId: userId,
                activities: selectedActivities,
                courses: selectedCourses,
                price: calculatedPrice,
                unlim: isUnlim
            )

            if !response.invoiceUrl.isEmpty, let url = URL(string: response.invoiceUrl) {
                invoiceUrl = url
                isShowingInvoice = true
            }
        } catch {
            logger.warning("Order request failed: \(error)")
            orderError = .orderFailed
            isShowingOrderError = true
        }
    }

    private func resolveUserId() -> String? {
        guard case let AppFlowState.authenticated(user) = appState.state else {
            return nil
        }
        return user.id
    }
}
