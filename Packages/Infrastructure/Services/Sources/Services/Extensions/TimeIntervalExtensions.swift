//
//  TimeIntervalExtensions.swift
//  Services
//
//  Created by Oleh Rozkvas on 27.03.2026.
//

import Foundation

extension TimeInterval {
    static let secondsInDay = 86_400 // 60 * 60 * 24

    static var month: TimeInterval {
        if let days = Calendar.current.range(of: .day, in: .month, for: Date())?.count {
            return from(days: days)
        } else {
            return from(days: 30)
        }
    }

    static var week: TimeInterval {
        return from(days: 7)
    }

    static var endOfWeek: TimeInterval {
        let now = Date()
        let endOfWeek = Calendar.mondayFirst.endOfWeek(for: now)
        return endOfWeek.timeIntervalSince(now)
    }

    static func from(days: Int) -> TimeInterval {
        guard let startOfTomorrow = Calendar.current.nextDate(
            after: Date(),
            matching: DateComponents(hour: 0, minute: 0, second: 0),
            matchingPolicy: .nextTime
        ) else {
            return 0
        }

        let remainingToday = startOfTomorrow.timeIntervalSince(Date())
        let sixFullDays = TimeInterval((days - 1) * secondsInDay)

        return remainingToday + sixFullDays
    }
}
