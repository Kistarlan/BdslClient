//
//  SubscriptionGroupCategory.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 24.02.2026.
//

import Foundation

public enum SubscriptionGroupCategory: Hashable {
    case date(Date)
    case subscriptionCategory(SubscriptionCategory)
}

extension SubscriptionGroupCategory: Identifiable {
    public var id: String {
        switch self {
        case let .date(date):
            return "date:\(date)"
        case let .subscriptionCategory(category):
            return "category:\(category)"
        }
    }
}

extension SubscriptionGroupCategory: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.subscriptionCategory(l), .subscriptionCategory(r)):
            return l < r

        case let (.date(l), .date(r)):
            return l < r

        case (.subscriptionCategory, .date):
            return true

        case (.date, .subscriptionCategory):
            return false
        }
    }
}
