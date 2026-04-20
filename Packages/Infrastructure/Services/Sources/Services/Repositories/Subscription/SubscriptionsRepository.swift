//
//  SubscriptionsRepository.swift
//  Services
//
//  Created by Oleh Rozkvas on 20.04.2026.
//

import Models

public protocol SubscriptionsRepository: Sendable {
    func fetchSettings() async throws -> SubscriptionSettings
}
