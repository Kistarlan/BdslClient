//
//  NotificationSettingsViewModel.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 25.03.2026.
//

import SwiftUI
import Models

@Observable
@MainActor
final class NotificationSettingsViewModel {
    private let appState: AppState

    var selected: NotificationLeadTime = .preset(1)
    var initialValue: NotificationLeadTime

    var isCustom: Bool {
        if case .custom = selected {
            return true
        }
        return false
    }

    var isChanged : Bool {
        initialValue != selected
    }

    static let presets = NotificationLeadTime.presets

    init(appState: AppState){
        self.appState = appState
        self.selected = appState.notificationLeadTime
        self.initialValue = appState.notificationLeadTime
    }

    func selectPreset(_ value: NotificationLeadTime) {
        selected = value
    }

    func selectCustom(_ hours: Int) {
        selected = .custom(hours)
    }

    func disable() {
        selected = .disabled
    }

    func save() {
        self.appState.notificationLeadTime = selected
    }
}
