//
//  NotificationBuilderImpl.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 29.03.2026.
//

import Models
import Foundation
import Services

final class NotificationBuilderImpl: Sendable, NotificationBuilder {
    let dateFormatter: DateFormatter

    init() {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        df.timeZone = .current
        df.locale = Locale.current
        df.doesRelativeDateFormatting = true

        dateFormatter = df
    }

    func buildNotifications(
        from classes: [UpcomingClassModel],
        leadTime: NotificationLeadTime
    ) -> [ClassNotification] {
        return classes.map { item in
            let fireDate = item.concreateTime.addingTimeInterval(TimeInterval(-leadTime.seconds))
            let classDate = getFormattedDate(item.concreateTime)
            let body = "\(NSLocalizedString("startsSoon", comment: ""))\n\(classDate)"

            return ClassNotification(
                id: makeId(classId: item.id, date: fireDate),
                title: item.event.title,
                body: body,
                fireDate: fireDate,
                classDate: item.concreateTime
            )
        }
    }

    private func makeId(classId: String, date: Date) -> String {
        "\(classId)_\(Int(date.timeIntervalSince1970))"
    }

    private func getFormattedDate(_ date: Date) -> String {
        dateFormatter.string(from: date)
    }
}

