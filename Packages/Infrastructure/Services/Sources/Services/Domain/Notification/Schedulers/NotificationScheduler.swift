//
//  NotificationScheduler.swift
//  Services
//
//  Created by Oleh Rozkvas on 26.03.2026.
//

import Models

public protocol NotificationScheduler: Sendable {
    func rebuildAll(
        classes: [UpcomingClassModel],
        leadTime: NotificationLeadTime
    ) async throws

    func reschedule(leadTime: NotificationLeadTime) async throws

    func cancelAll() async
}
