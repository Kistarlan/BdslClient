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
            appState: appState,
            permissionService: appServices.permissionService
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

    func makeUseSubscriptionsViewModel() -> UserSubscriptionsViewModel {
        UserSubscriptionsViewModel(
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

    func makeResetRequestPasswordViewModel() -> ResetRequestPasswordViewModel {
        ResetRequestPasswordViewModel(
            authRepository: appServices.authRepository
        )
    }

    func makeResetPasswordViewModel(inviteKey: ResetPasswordInviteKey) -> ResetPasswordViewModel {
        ResetPasswordViewModel(
            authRepository: appServices.authRepository,
            inviteKey: inviteKey
        )
    }

    func makeChangePasswordViewModel() -> ChangePasswordViewModel {
        ChangePasswordViewModel(authRepository: appServices.authRepository)
    }

    func makeBuySubscriptionViewModel() -> BuySubscriptionViewModel {
        BuySubscriptionViewModel(
            subscriptionsService: appServices.subscriptionService,
            appState: appState
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
