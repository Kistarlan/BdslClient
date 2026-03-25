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
    private let appState: AppState

    var isLoading: Bool = false
    var isLoaded: Bool = false
    var isInitialized: Bool = false
    var localizedError: LocalizedStringResource?
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

    func loadClasses(forceReload: Bool) async {
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

            upcomingClasses = try await fetchWithNetworkCheck(.seconds(5)) {
                try await self.userSubscriptionsService.loadUpcommingClasses(
                    for: user.id,
                    forceReload: forceReload
                )
            }

            isLoaded = true
            isInitialized = true

        } catch TaskError.timeout {
            logger.warning("Timeout")
            localizedError = .theRequestTimedOut

        } catch {
            logger.warning("Error: \(error.localizedDescription)")
        }
    }
}
