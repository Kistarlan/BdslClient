//
//  SubscriptionsService.swift
//  Services
//
//  Created by Oleh Rozkvas on 20.04.2026.
//

import Models

public protocol SubscriptionsService: CacheableService {
    func fetchAvailableSubscriptions(forceReload: Bool) async throws -> ([ActivitySubscription], [CourseSubscription])
    func fetchSettings() async throws -> SubscriptionSettings
    func requestOrder(
        userId: String,
        activities: [ActivitySubscription],
        courses: [CourseSubscription],
        price: Int,
        unlim: Bool
    ) async throws -> OrderResponseDTO
}
