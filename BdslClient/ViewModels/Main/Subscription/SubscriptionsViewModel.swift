//
//  SubscriptionsViewModel.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 19.02.2026.
//

import SwiftUI
import OSLog
import Models
import Services

@MainActor
@Observable
final class SubscriptionsViewModel {
    let logger = Logger.forCategory(String(describing: SubscriptionsViewModel.self))

    var groupingMode: SubscriptionsGroupingMode = .month
    var subscriptions: [UserSubscription] = []
    var isLoading: Bool = false
    var isInitialized: Bool = false
    var isLoaded: Bool = false
    var searchText: String = ""

    private var currentUser: User?
    private let userSubscriptionsService: UserSubscriptionsService
    private let appState: AppState

    init(userSubscriptionsService: UserSubscriptionsService,
         appState: AppState){
        self.userSubscriptionsService = userSubscriptionsService
        self.appState = appState
    }

    var grouped: [GroupedSection<SubscriptionGroupCategory, UserSubscription>] {
        switch groupingMode {
            case .category: groupedByCategory
            case .month: groupedByMonth
        }
    }

    var filteredSubscriptions : [UserSubscription] {
        if searchText == "" {
            return subscriptions
        }

        return subscriptions.filter { subscription in
            subscription.title.caseInsensitiveContains(searchText) ||
            subscription.category.title.localized.caseInsensitiveContains(searchText)
        }
    }

    var groupedByCategory: [GroupedSection<SubscriptionGroupCategory, UserSubscription>] {
        return filteredSubscriptions
            .grouped(by: \.category)
            .map {
                GroupedSection(
                    SubscriptionGroupCategory.subscriptionCategory($0.key),
                    $0.items
                )
            }
            .sorted { $0.key < $1.key }
    }

    var groupedByMonth: [GroupedSection<SubscriptionGroupCategory, UserSubscription>] {
        let calendar = Calendar.current

        return filteredSubscriptions
            .grouped { subscription in
                let date = subscription.endDate ?? subscription.startDate
                let components = calendar.dateComponents([.year, .month], from: date)
                let firstDay = calendar.date(from: components)!
                return firstDay
            }
            .sorted { $0.key > $1.key }
            .map { group in
                return GroupedSection(
                    SubscriptionGroupCategory.date(group.key),
                    group.items
                )
            }
            .sorted { $0.key > $1.key }
    }

    func fetchSubscriptions(forceReload: Bool) async {
        guard case let AppFlowState.authenticated(user) = appState.state else {
            logger.warning("Can't load user subscriptions, user is not authenticated")
            isLoaded = false

            return
        }

        if currentUser == user {
            if isLoaded && !forceReload {
                return
            }
        } else {
            currentUser = user
            isLoaded = false
        }

        isLoading = true
        defer {
            isLoading = false
            isInitialized = true
        }

        do {
            let userSubscriptions = try await userSubscriptionsService.fetchUserSubscriptions(for: user.id, forceReload: forceReload)
            subscriptions = userSubscriptions
                .sorted { firstSubscription, secondSubscription in
                    let firstDate = firstSubscription.endDate ?? firstSubscription.startDate
                    let secondDate = secondSubscription.endDate ?? secondSubscription.startDate

                    return firstDate > secondDate
                }
            
            isLoaded = true
        } catch {
            logger.warning("Can't load user subscriptions for \(user.id)")
        }
    }

    func togleGroupingMode() {
        withAnimation {
            groupingMode = groupingMode == .category ? .month : .category
        }
    }
}
