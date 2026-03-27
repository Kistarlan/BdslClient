//
//  NotificationManagerImpl.swift
//  Services
//
//  Created by Oleh Rozkvas on 27.03.2026.
//

final class NotificationManagerImpl: NotificationManager {
    private let notificationScheduler: NotificationScheduler
    private let appSettings: AppSettings
    private let userSubscriptionsService: UserSubscriptionsService

    init(
        notificationScheduler: NotificationScheduler,
        appSettings: AppSettings,
        userSubscriptionsService: UserSubscriptionsService
    ) {
        self.notificationScheduler = notificationScheduler
        self.appSettings = appSettings
        self.userSubscriptionsService = userSubscriptionsService
    }

    func initOrUpdateNotifications(for userId: String) async throws {
        let classes = try await userSubscriptionsService.loadUpcomingClasses(
            for: userId,
            range: .month,
            forceReload: false
        )

        try await notificationScheduler.rebuildAll(
            classes: classes,
            leadTime: appSettings.notificationLeadTime
        )
    }

    func cancelAll() async throws {
        await notificationScheduler.cancelAll()
    }
}
