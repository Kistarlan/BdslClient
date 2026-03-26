//
//  UpcomingClassesGenerator.swift
//  Services
//
//  Created by Oleh Rozkvas on 22.03.2026.
//


import Foundation
import OSLog
import Models

final class UpcomingClassesGenerator: UpcomingClassesGenerating {

    private let calendar: Calendar

    init(calendar: Calendar = Calendar.mondayFirst) {
        self.calendar = calendar
    }

    func generate(from classes: [ClassModel], now: Date = Date()) -> [UpcomingClassModel] {
        let endOfWeek = calendar.endOfWeek(for: now)

        return classes.flatMap { classModel in
            if let date = classModel.concreateTime {
                return [
                    UpcomingClassModel(
                        id: classModel.id,
                        event: classModel.event,
                        concreateTime: date
                    )
                ]
            } else {
                return generateRecurring(classModel: classModel, now: now, endOfWeek: endOfWeek)
            }
        }
    }
}

private extension UpcomingClassesGenerator {

    func generateRecurring(
        classModel: ClassModel,
        now: Date,
        endOfWeek: Date
    ) -> [UpcomingClassModel] {

        let event = classModel.event
        let recurrence = event.weeklyReccurance

        return recurrence.days.compactMap { day in
            guard let date = nextDate(for: day, from: now) else { return nil }

            guard date >= event.startDate else { return nil }
            guard date <= recurrence.untilDate else { return nil }
            guard date <= endOfWeek else { return nil }

            guard let finalDate = combine(date: date, timeFrom: event.startDate) else {
                return nil
            }

            return UpcomingClassModel(
                id: makeId(classModelId: classModel.id, date: finalDate),
                event: event,
                concreateTime: finalDate
            )
        }
    }

    func nextDate(for day: DayRecurrenceType, from date: Date) -> Date? {
        let weekday = day.weekdayNumber
        let calendar = self.calendar

        let todayWeekday = calendar.component(.weekday, from: date)

        if todayWeekday == weekday {
            return date
        }

        // Інакше шукаємо наступний weekday
        return calendar.nextDate(
            after: date,
            matching: DateComponents(weekday: weekday),
            matchingPolicy: .nextTimePreservingSmallerComponents
        )
    }

    func combine(date: Date, timeFrom: Date) -> Date? {
        let time = calendar.dateComponents([.hour, .minute], from: timeFrom)

        return calendar.date(
            bySettingHour: time.hour ?? 0,
            minute: time.minute ?? 0,
            second: 0,
            of: date
        )
    }

    func makeId(classModelId: String, date: Date) -> String {
        "\(classModelId)_\(Int(date.timeIntervalSince1970))"
    }
}

extension Calendar {
    static var mondayFirst: Calendar {
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Monday
        return calendar
    }

    func endOfWeek(for date: Date) -> Date {
        guard let interval = dateInterval(of: .weekOfYear, for: date) else {
            return date
        }

        return self.date(byAdding: .second, value: -1, to: interval.end)!
    }
}

extension DayRecurrenceType {
    var weekdayNumber: Int {
        switch self {
        case .sunday: return 1
        case .monday: return 2
        case .tueassday: return 3
        case .wednesday: return 4
        case .thursday: return 5
        case .friday: return 6
        case .saturday: return 7
        }
    }
}

