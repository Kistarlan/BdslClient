//
//  MainViewModel.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 11.02.2026.
//
import SwiftUI

@Observable
final class MainViewModel {
    let settingsViewModel: SettingsViewModel
    let subscriptionsViewModel: UserSubscriptionsViewModel
    let scheduleViewModel: ScheduleViewModel
    let myClassesViewModel: MyClassesViewModel

    init(
        settingsViewModel: SettingsViewModel,
        subscriptionsViewModel: UserSubscriptionsViewModel,
        scheduleViewModel: ScheduleViewModel,
        myClassesViewModel: MyClassesViewModel
    ) {
        self.settingsViewModel = settingsViewModel
        self.scheduleViewModel = scheduleViewModel
        self.subscriptionsViewModel = subscriptionsViewModel
        self.myClassesViewModel = myClassesViewModel
    }
}
