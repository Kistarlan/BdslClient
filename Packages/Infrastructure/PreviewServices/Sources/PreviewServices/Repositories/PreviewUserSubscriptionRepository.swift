//
//  PreviewUserSubscriptionRepository.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 25.02.2026.
//

import Models
import Services

final class PreviewUserSubscriptionRepository: UserSubscriptionsRepository {
    let previewDataProvider: PreviewDataProvider

    init(previewDataProvider: PreviewDataProvider) {
        self.previewDataProvider = previewDataProvider
    }

    func fetchUserSubscriptions(for userId: String) async throws -> [UserSubscriptionDTO] {
        let userSubscriptions = try previewDataProvider.load([UserSubscriptionDTO].self, from: "UserSubscriptions")

        return userSubscriptions.filter {$0.userId == userId}
    }

    func fetchSubscriptionAttendees(for userId: String) async throws -> [AttendeeDTO]{
        let attendeesDtos = try previewDataProvider.load([AttendeeDTO].self, from: "Attendees")

        return attendeesDtos.filter( { $0.userId == userId })
    }
}
