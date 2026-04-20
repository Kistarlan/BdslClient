//
//  SubscriptionsService.swift
//  Services
//
//  Created by Oleh Rozkvas on 20.04.2026.
//

import Models

public protocol SubscriptionsService: CacheableService {
    func fetchAvailableSubscriptions(forceReload: Bool) async throws -> ([ActivitySubscription], [CourseSubscription])
}
