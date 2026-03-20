//
//  UserSubscriptionsService.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 25.02.2026.
//

import Foundation
import Models

public protocol UserSubscriptionsService : CacheableService, UserCacheableService {
    func fetchUserSubscriptions(for id: String, forceReload: Bool) async throws -> [UserSubscription]
    func fetchSubscriptionAttendees(userSubscription: UserSubscription, forceReload: Bool) async throws -> [AttendeeModel]
}
