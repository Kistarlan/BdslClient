//
//  SubscriptionCategory.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 19.02.2026.
//

public enum SubscriptionCategory: String, CaseIterable, Hashable, Sendable {
    case active
    case credit
    case expired
    case volonteer
    case oneClassTicket
}

extension SubscriptionCategory : Identifiable {
    public var id: String { rawValue }
}

extension SubscriptionCategory : Comparable {
    public static func < (lhs: SubscriptionCategory, rhs: SubscriptionCategory) -> Bool {
        lhs.sortOrder < rhs.sortOrder
    }

    private var sortOrder: Int {
        switch self {
        case .active: return 0
        case .credit: return 1
        case .oneClassTicket: return 2
        case .volonteer: return 3
        case .expired: return 4
        }
    }
}
