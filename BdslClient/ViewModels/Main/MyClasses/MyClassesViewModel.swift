//
//  MyClassesViewModel.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 22.03.2026.
//

import Models
import OSLog
import Services
import SwiftUI

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
    var upcomingClasses: [UpcomingClassModel] = [] {
        didSet { rebuildGroupedClasses() }
    }

    private(set) var groupedClasses: [GroupedSection<Date, UpcomingClassModel>] = []

    var displayedSections: [GroupedSection<Date, UpcomingClassModel>] {
        if !isInitialized {
            [
                GroupedSection<Date, UpcomingClassModel>(
                    .now,
                    (0 ..< 5).map { _ in UpcomingClassModel.placeholder() }
                )
            ]
        } else {
            groupedClasses
        }
    }

    init(
        userSubscriptionsService: UserSubscriptionsService,
        appState: AppState
    ) {
        self.userSubscriptionsService = userSubscriptionsService
        self.appState = appState
    }

    func loadClasses(forceReload: Bool) async {
        guard handleNetwork(forceReload: forceReload) else { return }
        guard let user = resolveUser() else { return }

        await performLoad(for: user, forceReload: forceReload)
    }

    private func rebuildGroupedClasses() {
        let calendar = Calendar.current
        groupedClasses = Dictionary(grouping: upcomingClasses) {
            calendar.startOfDay(for: $0.concreateTime)
        }
        .map { GroupedSection($0.key, $0.value.sorted { $0.concreateTime < $1.concreateTime }) }
        .sorted { $0.key < $1.key }
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
                try await self.userSubscriptionsService.loadUpcomingClasses(
                    for: user.id,
                    range: .week,
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

    func retryLoad() {
        Task {
            await loadClasses(forceReload: false)
        }
    }
}
