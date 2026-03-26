//
//  ViewModelsFactory.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 06.02.2026.
//

import Models
import Services

struct ViewModelsFactory {
    private let appServices: AppServices
    private let appState: AppState

    init(
        appServices: AppServices,
        appState: AppState
    ) {
        self.appServices = appServices
        self.appState = appState
    }

    func makeLoginViewModel() -> LoginViewModel {
        LoginViewModel(
            authRepository: appServices.authRepository,
            appState: appState
        )
    }

    func makeMyClassesViewModel() -> MyClassesViewModel {
        MyClassesViewModel(
            userSubscriptionsService: appServices.userSubscriptionsService,
            appState: appState
        )
    }

    func makeSettingsViewModel() -> SettingsViewModel {
        SettingsViewModel(
            usersService: appServices.usersService,
            appState: appState,
            imageService: appServices.imageService
        )
    }

    func makeNotificationSettingsViewModel() -> NotificationSettingsViewModel {
        NotificationSettingsViewModel(
            appState: appState
        )
    }

    func makeMainViewModel() -> MainViewModel {
        MainViewModel(
            settingsViewModel: makeSettingsViewModel(),
            subscriptionsViewModel: makeUseSubscriptionsViewModel(),
            scheduleViewModel: makeScheduleViewModel(),
            myClassesViewModel: makeMyClassesViewModel()
        )
    }

    func makeEditUserInfoViewModel(user: User) -> EditUserInfoViewModel {
        EditUserInfoViewModel(
            user: user,
            appState: appState,
            usersService: appServices.usersService,
            imageService: appServices.imageService
        )
    }

    func makeUseSubscriptionsViewModel() -> SubscriptionsViewModel {
        SubscriptionsViewModel(
            userSubscriptionsService: appServices.userSubscriptionsService,
            appState: appState
        )
    }

    func makeAttendeesViewModel(userSubscription: UserSubscription) -> AttendeesViewModel {
        AttendeesViewModel(
            userSubscription: userSubscription,
            userSubscriptionsService: appServices.userSubscriptionsService
        )
    }

    func makeScheduleViewModel() -> ScheduleViewModel {
        ScheduleViewModel(
            appState: appState,
            groupsService: appServices.groupsService
        )
    }
}

extension ViewModelsFactory {
    func makePreviewMainViewModel() -> MainViewModel {
        return MainViewModel(
            settingsViewModel: AppContainer.shared.viewModelsFactory.makePreviewSettingsViewModel(),
            subscriptionsViewModel: makeUseSubscriptionsViewModel(),
            scheduleViewModel: makeScheduleViewModel(),
            myClassesViewModel: makeMyClassesViewModel()
        )
    }

    func makePreviewSettingsViewModel() -> SettingsViewModel {
        let vm = SettingsViewModel(
            usersService: appServices.usersService,
            appState: appState,
            imageService: appServices.imageService
        )

        return vm
    }
}
