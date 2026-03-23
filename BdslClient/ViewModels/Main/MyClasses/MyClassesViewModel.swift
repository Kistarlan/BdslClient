//
//  MyClassesViewModel.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 22.03.2026.
//

import SwiftUI
import OSLog
import Models
import Services

@MainActor
@Observable
final class MyClassesViewModel {
    private let logger = Logger.forCategory(String(describing: MyClassesViewModel.self))
    private let userSubscriptionsService: UserSubscriptionsService
    private var currentUser: User?
    private let appState: AppState

    var isLoading: Bool = false
    var isLoaded: Bool = false
    var isInitialized: Bool = false
    var upcomingClasses: [UpcomingClassModel] = []

    init(userSubscriptionsService: UserSubscriptionsService,
         appState: AppState) {
        self.userSubscriptionsService = userSubscriptionsService
        self.appState = appState
    }

    var groupedClasses: [GroupedSection<Date, UpcomingClassModel>] {
        let calendar = Calendar.current

        let grouped = Dictionary(grouping: upcomingClasses) {
            calendar.startOfDay(for: $0.concreateTime)
        }
        .map { key, items in
            GroupedSection(
                key,
                items.sorted { $0.concreateTime < $1.concreateTime }
            )
        }
        .sorted { $0.key < $1.key }

        return grouped
    }

    func loadSubscriptions(forceReload: Bool) async {
        guard case let AppFlowState.authenticated(user) = appState.state else {
            logger.warning("Can't load user subscriptions, user is not authenticated")
            isLoaded = false

            return
        }

        if forceReload {
            isLoaded = false
        }

        if currentUser == user {
            if isLoaded {
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
            upcomingClasses = try await userSubscriptionsService.loadUpcommingClasses(for: user.id, forceReload: forceReload)

            isLoaded = true
        } catch {
            logger.warning("Can't load user subscriptions for \(user.id)")
        }
    }
}
