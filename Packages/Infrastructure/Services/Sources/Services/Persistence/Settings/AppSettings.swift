//
//  AppSettings.swift
//  Services
//
//  Created by Oleh Rozkvas on 25.03.2026.
//

import Models

public protocol AppSettings : Sendable {
    var themeMode: ThemeMode { get set }
    var appLanguage: AppLanguage { get set }
    var notificationLeadTime: NotificationLeadTime { get set }
}
