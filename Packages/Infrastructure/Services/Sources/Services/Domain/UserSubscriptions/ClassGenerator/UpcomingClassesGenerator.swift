//
//  UpcomingClassesGenerator.swift
//  Services
//
//  Created by Oleh Rozkvas on 22.03.2026.
//

import Foundation
import Models
import OSLog

final class UpcomingClassesGenerator: UpcomingClassesGenerating {

    private let calendar: Calendar
    private let maxResults: Int

    init(
        calendar: Calendar = .mondayFirst,
        maxResults: Int = 64
    ) {
        self.calendar = calendar
        self.maxResults = maxResults
    }

    func generate(
        from classes: [ClassModel],
        now: Date = Date(),
        horizon: TimeInterval
    ) -> [UpcomingClassModel] {

        let endDate = now.addingTimeInterval(horizon)

        var results: [UpcomingClassModel] = []

        for classModel in classes {

            if let concrete = classModel.concreateTime {
                guard concrete >= now, concrete <= endDate else { continue }

                results.append(
                    UpcomingClassModel(
                        id: classModel.id,
                        event: classModel.event,
                        concreateTime: concrete
                    )
                )

                if results.count >= maxResults { break }
            } else {
                let generated = generateRecurring(
                    classModel: classModel,
                    now: now,
                    endDate: endDate
                )

                results.append(contentsOf: generated)

                if results.count >= maxResults { break }
            }
        }

        return results
            .sorted { $0.concreateTime < $1.concreateTime }
            .prefix(maxResults)
            .map { $0 }
    }
}

private extension UpcomingClassesGenerator {

    func generateRecurring(
        classModel: ClassModel,
        now: Date,
        endDate: Date
    ) -> [UpcomingClassModel] {

        let event = classModel.event
        let recurrence = event.weeklyReccurance

        var results: [UpcomingClassModel] = []

        for day in recurrence.days {

            guard var currentDate = nextDate(for: day, from: now) else {
                continue
            }

            while currentDate <= endDate {

                // combine date + time
                guard let finalDate = combine(date: currentDate, timeFrom: event.startDate) else {
                    break
                }

                // ❗ skip past
                if finalDate < now {
                    currentDate = nextWeekday(from: currentDate)
                    continue
                }

                // ❗ before event start
                if finalDate < event.startDate {
                    currentDate = nextWeekday(from: currentDate)
                    continue
                }

                // ❗ after recurrence end
                if finalDate > recurrence.untilDate {
                    break
                }

                results.append(
                    UpcomingClassModel(
                        id: makeId(classModelId: classModel.id, date: finalDate),
                        event: event,
                        concreateTime: finalDate
                    )
                )

                if results.count >= maxResults {
                    return results
                }

                currentDate = nextWeekday(from: currentDate)
            }
        }

        return results
    }
}

private extension UpcomingClassesGenerator {

    func nextDate(for day: DayRecurrenceType, from date: Date) -> Date? {
        let weekday = day.weekdayNumber

        let todayWeekday = calendar.component(.weekday, from: date)

        if todayWeekday == weekday {
            return calendar.startOfDay(for: date)
        }

        return calendar.nextDate(
            after: date,
            matching: DateComponents(weekday: weekday),
            matchingPolicy: .nextTimePreservingSmallerComponents
        )
    }

    func nextWeekday(from date: Date) -> Date {
        calendar.date(byAdding: .day, value: 7, to: date)!
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
