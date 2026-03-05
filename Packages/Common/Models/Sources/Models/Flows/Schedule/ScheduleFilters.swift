//
//  ScheduleFilters.swift
//  Models
//
//  Created by Oleh Rozkvas on 10.03.2026.
//

public struct ScheduleFilters {
    public var selectedLocationIds: Set<String> = []
    public var selectedActivityIds: Set<String> = []
    public var selectedTeacherIds: Set<String> = []
    public var selectedDays: Set<DayRecurrenceType> = []

    public var isEmpty: Bool {
        selectedLocationIds.isEmpty &&
        selectedActivityIds.isEmpty &&
        selectedTeacherIds.isEmpty &&
        selectedDays.isEmpty
    }

    public init() {}
}
