//
//  GroupModel.swift
//  Models
//
//  Created by Oleh Rozkvas on 19.03.2026.
//

import Foundation

public struct GroupModel: Identifiable, Hashable, Sendable {
    public let id: String
    public let teachers: [GroupTeacher]
    public let type: EventType
    public let startDate: Date
    public let endDate: Date
    public let recurrence: WeeklyRecurrence
    public let location: Location
    public let level: Level
    public let title: String
    public let activity: Activity
    public let duration: Int

    public init(
        id: String,
        teachers: [GroupTeacher],
        type: EventType,
        startDate: Date,
        endDate: Date,
        recurrence: WeeklyRecurrence,
        location: Location,
        level: Level,
        title: String,
        activity: Activity,
        duration: Int
    ) {
        self.id = id
        self.teachers = teachers
        self.type = type
        self.startDate = startDate
        self.endDate = endDate
        self.recurrence = recurrence
        self.location = location
        self.level = level
        self.title = title
        self.activity = activity
        self.duration = duration
    }
}
