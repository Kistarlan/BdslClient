//
//  SubscriptionGroupCategory.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 24.02.2026.
//

import Foundation

public enum SubscriptionGroupCategory : Hashable {
    case date(Date)
    case subscriptionCategory(SubscriptionCategory)
}

extension SubscriptionGroupCategory : Identifiable {
    public var id: String {
        switch self {
        case .date(let date):
            return "date:\(date)"
        case .subscriptionCategory(let category):
            return "category:\(category)"
        }
    }
}

extension SubscriptionGroupCategory: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {

        case (.subscriptionCategory(let l), .subscriptionCategory(let r)):
            return l < r

        case (.date(let l), .date(let r)):
            return l < r

        case (.subscriptionCategory, .date):
            return true

        case (.date, .subscriptionCategory):
            return false
        }
    }
}
