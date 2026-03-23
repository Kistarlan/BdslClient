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
    let subscriptionsViewModel: SubscriptionsViewModel
    let scheduleViewModel: ScheduleViewModel
    let myClassesViewModel: MyClassesViewModel

    init(
        settingsViewModel: SettingsViewModel,
        subscriptionsViewModel: SubscriptionsViewModel,
        scheduleViewModel: ScheduleViewModel,
        myClassesViewModel: MyClassesViewModel
    ) {
        self.settingsViewModel = settingsViewModel
        self.scheduleViewModel = scheduleViewModel
        self.subscriptionsViewModel = subscriptionsViewModel
        self.myClassesViewModel = myClassesViewModel
    }
}
