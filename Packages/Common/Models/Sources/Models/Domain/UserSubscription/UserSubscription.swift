//
//  UserSubscription.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 19.02.2026.
//

import Foundation

public struct UserSubscription: Identifiable, Hashable, Sendable {
    // MARK: - Common properties

    public let id: String
    public let activities: [Activity]
    public let visitsIds: [String]
    public let userId: String
    public let title: String
    public let startDate: Date

    // MARK: - Regular subscription properties

    public let endDate: Date?
    public let unlimited: Bool?
    public let visitsLimit: Int?
    public let paymentMethod: PaymentMethod?
    public let price: Double?

    // MARK: - Credit subscription property

    public let closed: Bool?

    // MARK: - Calculated properties

    public let category: SubscriptionCategory

    // MARK: - Public initializer

    public init(
        id: String,
        activities: [Activity],
        visitsIds: [String],
        userId: String,
        title: String,
        startDate: Date,
        endDate: Date? = nil,
        unlimited: Bool? = nil,
        visitsLimit: Int? = nil,
        paymentMethod: PaymentMethod? = nil,
        price: Double? = nil,
        closed: Bool? = nil,
        category: SubscriptionCategory
    ) {
        self.id = id
        self.activities = activities
        self.visitsIds = visitsIds
        self.userId = userId
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.unlimited = unlimited
        self.visitsLimit = visitsLimit
        self.paymentMethod = paymentMethod
        self.price = price
        self.closed = closed
        self.category = category
    }
}

public extension UserSubscription {
    var remainingLessons: Int? {
        if let limits = visitsLimit {
            return limits - visitsIds.count
        } else if let unlim = unlimited, unlim {
            return 100 - visitsIds.count
        } else {
            return nil
        }
    }

    var badgeLessonsCount: Int? {
        switch category {
        case .active:
            return remainingLessons
        case .credit:
            if let closed = closed, !closed {
                return visitsIds.count
            } else {
                return nil
            }
        default:
            return nil
        }
    }

    func dateRangeText(locale: Locale) -> String? {
        let formatStyle = Date.FormatStyle()
            .day()
            .month(.abbreviated)
            .year()
            .locale(locale)

        switch category {
        case .active, .expired:
            if let endDate {
                return "\(startDate.formatted(formatStyle)) – \(endDate.formatted(formatStyle))"
            } else {
                return startDate.formatted(formatStyle)
            }

        case .oneClassTicket:
            return startDate.formatted(formatStyle)

        default:
            return nil
        }
    }

    var isExpiredSoon: Bool {
        if let endDate = endDate {
            // Less than 5 days
            return endDate.timeIntervalSinceNow < 60 * 60 * 24 * 5
        }

        if let remainingLessons, remainingLessons <= 2 {
            return true
        }

        return false
    }
}
