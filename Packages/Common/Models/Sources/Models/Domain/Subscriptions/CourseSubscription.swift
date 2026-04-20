//
//  CourseSubscription.swift
//  Models
//
//  Created by Oleh Rozkvas on 20.04.2026.
//

public struct CourseSubscription: Sendable {
    public let activity: Activity
    public let subscription: EventSubscription
    public var id: String {
        subscription.id
    }

    public init(activity: Activity, subscription: EventSubscription) {
        self.activity = activity
        self.subscription = subscription
    }
}
