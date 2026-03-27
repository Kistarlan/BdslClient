//
//  ClassGeneratingRange.swift
//  Models
//
//  Created by Oleh Rozkvas on 27.03.2026.
//

public enum ClassGeneratingRange: Equatable, Sendable {
    case endOfWeek
    case week
    case month
    case days(Int)
}

public extension ClassGeneratingRange {
    var description: String {
        switch self {
        case .endOfWeek:
            return "end Of Week"
        case .week:
            return "week"
        case .month:
            return "month"
        case let .days(count):
            return "days(\(count))"
        }
    }
}
