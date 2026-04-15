//
//  MockPermissionService.swift
//  BdslClientTests
//

import Services

@MainActor
final class MockPermissionService: PermissionService {
    var notificationGranted = true

    func requestNotificationPermission() async -> Bool { notificationGranted }
    func isNotificationPermissionGranted() async -> Bool { notificationGranted }
    func openSettings() {}
}
