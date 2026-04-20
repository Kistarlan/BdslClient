//
//  CourseSubscription.swift
//  Models
//
//  Created by Oleh Rozkvas on 20.04.2026.
//

public struct CourseSubscription: Sendable {
    public let activity: Activity
    public let subscription: EventSubscription
    public let title: String
    public var id: String {
        subscription.id
    }

    public init(
        activity: Activity,
        subscription: EventSubscription,
        title: String) {
        self.activity = activity
        self.subscription = subscription
        self.title = title
    }
}
