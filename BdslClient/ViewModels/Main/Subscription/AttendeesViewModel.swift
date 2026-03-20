//
//  AttendeesViewModel.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 24.02.2026.
//

import SwiftUI
import OSLog
import Models
import Services

@MainActor
@Observable
final class AttendeesViewModel {
    private let logger = Logger.forCategory(String(describing: AttendeesViewModel.self))
    private let userSubscriptionsService: UserSubscriptionsService

    let userSubscription: UserSubscription

    var attendees: [AttendeeModel] = []
    var isLoading = false

    init(
        userSubscription: UserSubscription,
        userSubscriptionsService: UserSubscriptionsService
    ) {
        self.userSubscription = userSubscription
        self.userSubscriptionsService = userSubscriptionsService
    }

    func fetchAttendees(forceReload: Bool) async {
        guard attendees.isEmpty else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            attendees = try await userSubscriptionsService.fetchSubscriptionAttendees(userSubscription: userSubscription, forceReload: false)
        } catch {
            logger.error("can't load attendees for subscription: \(self.userSubscription.id)")
        }
    }
}
