//
//  NotificationServiceImpl.swift
//  Services
//
//  Created by Oleh Rozkvas on 26.03.2026.
//

import UserNotifications
import Models

actor NotificationServiceImpl: NotificationService {
    private static let classIdKey = "classId"
    private static let classDateKey = "classDate"
    private static let titleKey = "titleKey"
    private static let bodyKey = "bodyKey"
    private let center = UNUserNotificationCenter.current()

    func schedule(_ notification: ClassNotification) async throws {
        let content = UNMutableNotificationContent()
        content.title = notification.title
        content.body = notification.body
        content.userInfo = [
            NotificationServiceImpl.classIdKey: notification.id,
            NotificationServiceImpl.classDateKey: notification.classDate.timeIntervalSince1970,
            NotificationServiceImpl.titleKey: notification.title,
            NotificationServiceImpl.bodyKey: notification.body
        ]

        let interval = notification.fireDate.timeIntervalSinceNow// + TimeInterval(minutes * 60) - for debug only

        //for debug only
        print("interval: \(Int(interval) / 3600)h \(Int(interval)%3600 / 60)m \(Int(interval) % 60) where fireDate: \(notification.fireDate) and classDate: \(notification.classDate)")
        guard interval > 0 else { return }

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: interval,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: notification.id,
            content: content,
            trigger: trigger
        )

        try await center.add(request)
    }

    func remove(ids: [String]) async {
        center.removePendingNotificationRequests(withIdentifiers: ids)
    }

    func removeAll() async {
        center.removeAllPendingNotificationRequests()
    }

    func getPending() async -> [PendingNotification] {
        let requests = await center.pendingNotificationRequests()

        return requests.compactMap { request in
            let userInfo = request.content.userInfo

            guard
                let classId = userInfo[NotificationServiceImpl.classIdKey] as? String,
                let timestamp = userInfo[NotificationServiceImpl.classDateKey] as? TimeInterval,
                let title = userInfo[NotificationServiceImpl.titleKey] as? String,
                let body = userInfo[NotificationServiceImpl.bodyKey] as? String
            else {
                return nil
            }

            return PendingNotification(
                id: request.identifier,
                classId: classId,
                title: title,
                body: body,
                classDate: Date(timeIntervalSince1970: timestamp)
            )
        }
    }
}
