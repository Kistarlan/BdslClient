//
//  ScheduleEventSection.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 03.03.2026.
//

public struct ScheduleEventSection: Identifiable, Hashable, Sendable {
    public let days: Set<DayRecurrenceType>
    public let events: [EventModel]

    public var id: String {
        days
            .sorted()
            .map { String($0.rawValue) }
            .joined(separator: "-")
    }

    public var sortedDays: [DayRecurrenceType] {
        days.sorted()
    }

    public init(days: Set<DayRecurrenceType>, events: [EventModel]) {
        self.days = days
        self.events = events
    }
}
