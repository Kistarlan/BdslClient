//
//  NotificationBuilderImpl.swift
//  Services
//
//  Created by Oleh Rozkvas on 26.03.2026.
//

import Models
import Foundation

final class NotificationBuilderImpl: NotificationBuilder {

    func buildNotifications(
        from classes: [UpcomingClassModel],
        leadTime: NotificationLeadTime
    ) -> [ClassNotification] {

        var number: Int = 0
        return classes.map { item in

            number+=1
            let fireDate = Date().addingTimeInterval( TimeInterval(60 + number * 30))
            //let fireDate = item.concreateTime.addingTimeInterval(TimeInterval(-leadTime.seconds))

            return ClassNotification(
                id: makeId(classId: item.id, date: fireDate),
                title: item.event.title,
                body: "Starts soon",
                fireDate: fireDate,
                classDate: item.concreateTime
            )
        }
    }

    private func makeId(classId: String, date: Date) -> String {
        "\(classId)_\(Int(date.timeIntervalSince1970))"
    }
}
