//
//  NotificationBuilder.swift
//  Services
//
//  Created by Oleh Rozkvas on 26.03.2026.
//

import Models

protocol NotificationBuilder {
    func buildNotifications(
        from classes: [UpcomingClassModel],
        leadTime: NotificationLeadTime
    ) -> [ClassNotification]
}
