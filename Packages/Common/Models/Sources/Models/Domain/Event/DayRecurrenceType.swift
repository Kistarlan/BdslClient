//
//  DayRecurrenceType.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 20.02.2026.
//

public enum DayRecurrenceType: String, Decodable, CaseIterable, Sendable {
    case monday = "mo"
    case tueassday = "tu"
    case wednesday = "we"
    case thursday = "th"
    case friday = "fr"
    case saturday = "sa"
    case sunday = "su"
}

extension DayRecurrenceType: Identifiable {
    public var id: Self { self }
}

extension DayRecurrenceType: Comparable {
    public static func < (lhs: DayRecurrenceType, rhs: DayRecurrenceType) -> Bool {
        lhs.sortOrder < rhs.sortOrder
    }

    private var sortOrder: Int {
        switch self {
        case .monday: return 0
        case .tueassday: return 1
        case .wednesday: return 2
        case .thursday: return 3
        case .friday: return 4
        case .saturday: return 5
        case .sunday: return 6
        }
    }
}
