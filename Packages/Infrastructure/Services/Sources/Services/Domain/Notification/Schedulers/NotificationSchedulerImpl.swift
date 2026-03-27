//
//  NotificationSchedulerImpl.swift
//  Services
//
//  Created by Oleh Rozkvas on 26.03.2026.
//

import Models
import Foundation

actor NotificationSchedulerImpl: NotificationScheduler {
    private let service: NotificationService
    private let builder: NotificationBuilder

    init(service: NotificationBuilder, manager: NotificationService) {
        self.builder = service
        self.service = manager
    }

    func rebuildAll(
        classes: [UpcomingClassModel],
        leadTime: NotificationLeadTime
    ) async throws {

        let notifications = builder.buildNotifications(
            from: classes,
            leadTime: leadTime
        )

        await service.removeAll()

        for notification in notifications {
            try await service.schedule(notification)
        }
    }

    func reschedule(leadTime: NotificationLeadTime) async throws {
        let pending = await service.getPending()

        await service.removeAll()

        for item in pending {
            let newFireDate = item.classDate.addingTimeInterval(TimeInterval(-leadTime.seconds))

            guard newFireDate > Date() else { continue }

            let notification = ClassNotification(
                id: item.id,
                title: item.title,
                body: item.body,
                fireDate: newFireDate,
                classDate: item.classDate
            )

            try await service.schedule(notification)
        }
    }

    func cancelAll() async {
        await service.removeAll()
    }
}
