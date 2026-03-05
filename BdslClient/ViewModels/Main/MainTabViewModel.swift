//
//  MainTabViewModel.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 11.02.2026.
//
import SwiftUI

@Observable
final class MainTabViewModel {
    let settingsViewModel: SettingsViewModel
    let subscriptionsViewModel: SubscriptionsViewModel
    let scheduleViewModel: ScheduleViewModel

    init(
        settingsViewModel: SettingsViewModel,
        subscriptionsViewModel: SubscriptionsViewModel,
        scheduleViewModel: ScheduleViewModel,
    ) {
        self.settingsViewModel = settingsViewModel
        self.scheduleViewModel = scheduleViewModel
        self.subscriptionsViewModel = subscriptionsViewModel
    }
}
