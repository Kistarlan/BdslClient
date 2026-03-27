//
//  File.swift
//  Services
//
//  Created by Oleh Rozkvas on 27.03.2026.
//

import Foundation

extension Calendar {
    static var mondayFirst: Calendar {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        return calendar
    }

    func endOfWeek(for date: Date) -> Date {
        guard let interval = dateInterval(of: .weekOfYear, for: date) else {
            return date
        }

        return self.date(byAdding: .second, value: -1, to: interval.end)!
    }
}
