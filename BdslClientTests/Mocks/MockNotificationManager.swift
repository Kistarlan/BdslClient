//
//  MockNotificationManager.swift
//  BdslClientTests
//

import Services

final class MockNotificationManager: NotificationManager, @unchecked Sendable {
    func initOrUpdateNotifications(for userId: String) async throws {}
    func cancelAll() async throws {}
}
