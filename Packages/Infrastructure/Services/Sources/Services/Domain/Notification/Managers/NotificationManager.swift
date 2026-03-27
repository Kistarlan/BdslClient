//
//  NotificationManager.swift
//  Services
//
//  Created by Oleh Rozkvas on 27.03.2026.
//

public protocol NotificationManager: Sendable {
    func initOrUpdateNotifications(for userId: String) async throws
    func cancelAll() async throws
}
