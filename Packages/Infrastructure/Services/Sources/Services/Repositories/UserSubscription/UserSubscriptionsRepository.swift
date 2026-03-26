//
//  UserSubscriptionsRepository.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 20.02.2026.
//

import Foundation
import Models

public protocol UserSubscriptionsRepository: Sendable {
    func fetchUserSubscriptions(for userId: String) async throws -> [UserSubscriptionDTO]
    func fetchSubscriptionAttendees(for userId: String) async throws -> [AttendeeDTO]
}
