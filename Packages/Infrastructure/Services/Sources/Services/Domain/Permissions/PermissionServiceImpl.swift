//
//  PermissionServiceImpl.swift
//  Services
//
//  Created by Oleh Rozkvas on 30.03.2026.
//

import UserNotifications
import Models
import OSLog
import UIKit

@MainActor
final class PermissionServiceImpl: PermissionService {
    private let logger = Logger.forCategory(String(describing: ActivityServiceImpl.self))

    func requestNotificationPermission() async -> Bool {
        let center = UNUserNotificationCenter.current()

        do {
            let granted = try await center.requestAuthorization(
                options: [.alert, .sound, .badge]
            )

            if granted {
                logger.info("✅ Notifications allowed")
            } else {
                logger.info("❌ Notifications denied")
            }

            return granted
        } catch {
            logger.info("❌ Error: \(error)")

            return false
        }
    }

    func isNotificationPermissionGranted() async -> Bool {
        let settings = await UNUserNotificationCenter.current().notificationSettings()

        switch settings.authorizationStatus {
        case .authorized, .provisional:
            return true
        default:
            return false
        }
    }

    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}
