import SwiftUI
import Navigation

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
    default:
        LoginBackgroundView()
    }
}

@ViewBuilder func view(for destination: SheetDestination) -> some View {
    Group {
        switch destination {
        case let .groupDescription(group):
            GroupDetailsSheet(group: group)
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
