import Models
import Navigation
import SwiftUI

@ViewBuilder func view(for destination: PushDestination) -> some View {
    let vmFactory = AppContainer.shared.viewModelsFactory

    switch destination {
    case .languageSettings:
        LanguagePickerView()
    case .themeSettings:
        ThemePickerView()
    case let .changeUserInfo(user):
        EditUserInfoView(viewModel: vmFactory.makeEditUserInfoViewModel(user: user))
    case .settings:
        SettingsScreen(settingsViewModel: vmFactory.makeSettingsViewModel())
    case let .subsctiptionDetails(userSubscription):
        AttendeesScreen(attendeesViewModel: vmFactory.makeAttendeesViewModel(userSubscription: userSubscription))
    case .login:
        LoginScreen(vmFactory.makeLoginViewModel())
    case .notificationSettings:
        NotificationSettingsScreen(viewModel: vmFactory.makeNotificationSettingsViewModel())
    default:
        LoginBackgroundView()
    }
}

@ViewBuilder func view(for destination: SheetDestination) -> some View {
    Group {
        switch destination {
        case let .groupDescription(group):
            GroupDetailsSheet(group: group)
        case let .eventDescription(event):
            GroupDetailsSheet(group: event.toGroup())
        }
    }
}

@ViewBuilder func view(for destination: FullScreenDestination) -> some View {
    Group {
        LoginBackgroundView()
    }
    .addDismissButton(.close)
    .presentationBackground(.black)
}
