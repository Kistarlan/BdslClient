//
//  MockAppSettings.swift
//  BdslClientTests
//

import Models
import Services

final class MockAppSettings: AppSettings, @unchecked Sendable {
    var themeMode: ThemeMode
    var appLanguage: AppLanguage
    var notificationLeadTime: NotificationLeadTime

    init(
        themeMode: ThemeMode = .system,
        appLanguage: AppLanguage = .system,
        notificationLeadTime: NotificationLeadTime = .disabled
    ) {
        self.themeMode = themeMode
        self.appLanguage = appLanguage
        self.notificationLeadTime = notificationLeadTime
    }
}
