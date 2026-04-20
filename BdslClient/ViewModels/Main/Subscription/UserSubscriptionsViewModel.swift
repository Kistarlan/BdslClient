//
//  UserSubscriptionsViewModel.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 19.02.2026.
//

import Models
import OSLog
import Services
import SwiftUI

@MainActor
@Observable
final class UserSubscriptionsViewModel {
    private let logger = Logger.forCategory(String(describing: UserSubscriptionsViewModel.self))

    var groupingMode: SubscriptionsGroupingMode = .month {
        didSet { updateDisplayedGroupsIfInitialized() }
    }

    var subscriptions: [UserSubscription] = []
    var isLoading: Bool = false
    var isInitialized: Bool = false
    var searchText: String = "" {
        didSet { updateDisplayedGroupsIfInitialized() }
    }

    var localizedError: LocalizedStringResource?

    private(set) var displayedGroups: [GroupedSection<SubscriptionGroupCategory, UserSubscription>] = [
        GroupedSection(.subscriptionCategory(.active), (0 ..< 5).map { _ in .placeholder() })
    ]

    private let userSubscriptionsService: UserSubscriptionsService
    private let appState: AppState

    init(
        userSubscriptionsService: UserSubscriptionsService,
        appState: AppState
    ) {
        self.userSubscriptionsService = userSubscriptionsService
        self.appState = appState
    }

    private var filteredSubscriptions: [UserSubscription] {
        if searchText.isEmpty {
            return subscriptions
        }

        return subscriptions.filter { subscription in
            subscription.title.localizedStandardContains(searchText) ||
                subscription.category.title.localized.localizedStandardContains(searchText)
        }
    }

    private var groupedByCategory: [GroupedSection<SubscriptionGroupCategory, UserSubscription>] {
        filteredSubscriptions
            .grouped(by: \.category)
            .map {
                GroupedSection(
                    SubscriptionGroupCategory.subscriptionCategory($0.key),
                    $0.items
                )
            }
            .sorted { $0.key < $1.key }
    }

    private var groupedByMonth: [GroupedSection<SubscriptionGroupCategory, UserSubscription>] {
        let calendar = Calendar.current

        return filteredSubscriptions
            .grouped { subscription in
                let date = subscription.endDate ?? subscription.startDate
                let components = calendar.dateComponents([.year, .month], from: date)
                return calendar.date(from: components) ?? Date.now
            }
            .map { group in
                GroupedSection(
                    SubscriptionGroupCategory.date(group.key),
                    group.items
                )
            }
            .sorted { $0.key > $1.key }
    }

    private func updateDisplayedGroupsIfInitialized() {
        guard isInitialized else { return }
        updateDisplayedGroups()
    }

    private func updateDisplayedGroups() {
        displayedGroups = switch groupingMode {
        case .category: groupedByCategory
        case .month: groupedByMonth
        }
    }

    func fetchSubscriptions(forceReload: Bool) async {
        guard handleNetwork(forceReload: forceReload) else { return }
        guard let user = resolveUser() else { return }

        await performLoad(for: user, forceReload: forceReload)
    }

    private func handleNetwork(forceReload: Bool) -> Bool {
        if appState.isNetworkAvailable {
            return true
        }

        if forceReload || !isInitialized {
            localizedError = .noInternetConnection
        }

        return false
    }

    private func resolveUser() -> User? {
        guard case let AppFlowState.authenticated(user) = appState.state else {
            logger.warning("User is not authenticated")
            return nil
        }

        return user
    }

    private func performLoad(for user: User, forceReload: Bool) async {
        isLoading = true
        defer { isLoading = false }

        do {
            localizedError = nil

            let userSubscriptions = try await fetchWithNetworkCheck(.seconds(5)) {
                try await self.userSubscriptionsService.fetchUserSubscriptions(
                    for: user.id,
                    forceReload: forceReload
                )
            }

            subscriptions = userSubscriptions
                .sorted { firstSubscription, secondSubscription in
                    let firstDate = firstSubscription.endDate ?? firstSubscription.startDate
                    let secondDate = secondSubscription.endDate ?? secondSubscription.startDate

                    return firstDate > secondDate
                }

            isInitialized = true
            updateDisplayedGroups()

        } catch TaskError.timeout {
            logger.warning("Timeout")
            localizedError = .theRequestTimedOut

        } catch {
            logger.warning("Error: \(error.localizedDescription)")
        }
    }

    func togleGroupingMode() {
        withAnimation {
            groupingMode = groupingMode == .category ? .month : .category
        }
    }
}
