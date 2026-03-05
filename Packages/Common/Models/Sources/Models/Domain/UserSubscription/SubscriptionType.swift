//
//  SubscriptionType.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 20.02.2026.
//

import Foundation

public enum SubscriptionType: String, Codable, Sendable {
    case regular = "Regular"
    case credit = "Credit"
    case volunteer = "Volunteer"
    case ticket = "Ticket"
}
