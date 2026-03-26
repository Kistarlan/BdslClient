//
//  ScheduleGroupSection.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 03.03.2026.
//

public struct ScheduleGroupSection: Identifiable, Hashable, Sendable {
    public let days: Set<DayRecurrenceType>
    public let groups: [GroupModel]

    public var id: String {
        days
            .sorted()
            .map { String($0.rawValue) }
            .joined(separator: "-")
    }

    public var sortedDays: [DayRecurrenceType] {
        days.sorted()
    }

    public init(days: Set<DayRecurrenceType>, events: [GroupModel]) {
        self.days = days
        groups = events
    }
}
