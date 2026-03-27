//
//  NotificationService.swift
//  Services
//
//  Created by Oleh Rozkvas on 26.03.2026.
//

import Models

protocol NotificationService: Sendable {
    func schedule(_ notification: ClassNotification) async throws
    func remove(ids: [String]) async
    func removeAll() async
    func getPending() async -> [PendingNotification]
}
