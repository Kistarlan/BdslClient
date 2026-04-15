//
//  GroupModelFactory.swift
//  BdslClientTests
//

import Foundation
import Models

/// Builds GroupModel test fixtures for ScheduleViewModel tests.
enum GroupModelFactory {
    static func makeGroup(
        id: String = UUID().uuidString,
        locationId: String = "loc-1",
        activityId: String = "act-1",
        teacherId: String = "teacher-1",
        days: [DayRecurrenceType] = [.monday]
    ) -> GroupModel {
        GroupModel(
            id: id,
            teachers: [
                GroupTeacher(id: teacherId, name: "Anna", surname: "Smith", fullName: "Anna Smith")
            ],
            type: .group,
            startDate: Date(),
            endDate: Date().addingTimeInterval(60 * 60),
            recurrence: WeeklyRecurrence(
                id: "rec-\(id)",
                interval: 90,
                untilDate: Date().addingTimeInterval(60 * 60 * 24 * 30),
                days: days
            ),
            location: Location(
                id: locationId,
                title: "Location \(locationId)",
                address: "",
                colorHex: "#000000",
                color2Hex: "#111111"
            ),
            level: Level(id: "level-1", colorHex: "#ffffff", title: "Beginner"),
            title: "Group \(id)",
            activity: Activity(id: activityId, colorHex: "#00ff00", title: "Activity \(activityId)"),
            duration: 90
        )
    }
}
