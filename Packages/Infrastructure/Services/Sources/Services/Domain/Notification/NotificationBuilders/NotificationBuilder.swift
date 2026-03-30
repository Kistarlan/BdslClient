//
//  NotificationBuilder.swift
//  Services
//
//  Created by Oleh Rozkvas on 26.03.2026.
//

import Models

public protocol NotificationBuilder: Sendable {
    func buildNotifications(
        from classes: [UpcomingClassModel],
        leadTime: NotificationLeadTime
    ) -> [ClassNotification]
}
