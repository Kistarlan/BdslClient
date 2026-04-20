//
//  ActivitySubscription.swift
//  Models
//
//  Created by Oleh Rozkvas on 20.04.2026.
//

public struct ActivitySubscription: Sendable, Identifiable {
    public let activity: Activity
    public var id: String {
        activity.id
    }

    public init(activity: Activity) {
        self.activity = activity
    }
}
