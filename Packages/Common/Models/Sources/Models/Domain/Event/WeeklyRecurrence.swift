//
//  WeeklyRecurrence.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 02.03.2026.
//
import Foundation

public struct WeeklyRecurrence: Hashable, Sendable {
    public let id: String
    public let interval: Int
    public let untilDate: Date
    public let days: [DayRecurrenceType]

    // 🔹 Public init
    public init(
        id: String,
        interval: Int,
        untilDate: Date,
        days: [DayRecurrenceType]
    ) {
        self.id = id
        self.interval = interval
        self.untilDate = untilDate
        self.days = days
    }
}
