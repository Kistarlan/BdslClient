//
//  NotificationSettingsViewModel.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 25.03.2026.
//

import Models
import Services
import SwiftUI

@Observable
@MainActor
final class NotificationSettingsViewModel {
    private let appState: AppState
    private let permissionService: PermissionService

    var selected: NotificationLeadTime
    var initialValue: NotificationLeadTime
    var showWarning: Bool

    var showCustomSelection: Bool
    var isCustom: Bool {
        if case .custom = selected {
            return true
        }
        return false
    }

    var isChanged: Bool {
        initialValue != selected
    }

    static let presets = NotificationLeadTime.presets

    init(appState: AppState,
         permissionService: PermissionService) {
        self.appState = appState
        self.permissionService = permissionService
        selected = appState.notificationLeadTime
        initialValue = appState.notificationLeadTime

        showWarning = false
        showCustomSelection = false
    }

    func openAppSettings() {
        permissionService.openSettings()
    }

    func requestNotificationPermission() async {
        let granted = await permissionService.requestNotificationPermission()

        showWarning = !granted
    }

    func selectPreset(_ value: NotificationLeadTime) {
        selected = value
        showCustomSelection = false
    }

    func selectCustom(_ hours: Int) {
        selected = .custom(hours)
        showCustomSelection = true
    }

    func disable() {
        selected = .disabled
        showCustomSelection = false
    }

    func save() {
        Task {
            await appState.updateNotificationSettings(selected)
        }
    }
}
