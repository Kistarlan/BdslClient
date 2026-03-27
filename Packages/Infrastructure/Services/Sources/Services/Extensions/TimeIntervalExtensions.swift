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
            return Self.init(secondsInDay * days)
        } else {
            return Self.init(secondsInDay * 30)
        }
    }

    static var week: TimeInterval {
        return Self.init(secondsInDay * 7)
    }

    static var endOfWeek: TimeInterval {
        let now = Date()
        let endOfWeek = Calendar.mondayFirst.endOfWeek(for: now)
        return endOfWeek.timeIntervalSince(now)
    }

    static func from(days: Int) -> TimeInterval {
        .init(secondsInDay * days)
    }
}
