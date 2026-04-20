//
//  EventModel.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 25.02.2026.
//

import Foundation

public struct EventModel: Hashable, Sendable, Identifiable {
    public let id: String
    public let teachers: [TeacherModel]
    public let type: EventType
    public let weeklyReccurance: WeeklyRecurrence
    public let startDate: Date
    public let endDate: Date
    public let location: Location
    public let level: Level
    public let title: String
    public let activity: Activity
    public let eventSubscription: EventSubscription?

    public init(
        id: String,
        teachers: [TeacherModel],
        type: EventType,
        weeklyReccurance: WeeklyRecurrence,
        startDate: Date,
        endDate: Date,
        location: Location,
        level: Level,
        title: String,
        activity: Activity,
        eventSubscription: EventSubscription?
    ) {
        self.id = id
        self.teachers = teachers
        self.type = type
        self.weeklyReccurance = weeklyReccurance
        self.startDate = startDate
        self.endDate = endDate
        self.location = location
        self.level = level
        self.title = title
        self.activity = activity
        self.eventSubscription = eventSubscription
    }
}
