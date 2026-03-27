//
//  AppSettingsObserving.swift
//  Services
//
//  Created by Oleh Rozkvas on 26.03.2026.
//

import Models

public protocol AppSettingsObserving {
    var notificationLeadTimeDidChange: AsyncStream<NotificationLeadTime> { get }
}
