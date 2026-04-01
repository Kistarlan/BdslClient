//
//  SettingsView.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 03.02.2026.
//

import DesignSystem
import Models
import Navigation
import SwiftUI

struct SettingsView: View {
    @Environment(\.theme) private var theme
    @Environment(AppState.self) private var appState
    @Bindable var viewModel: SettingsViewModel
    @Environment(Router.self) private var router
    @Environment(\.locale) private var locale

    var avatarImage: UIImage? {
        guard let avatarData = viewModel.avatarData else { return nil }
        return UIImage(data: avatarData)
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: theme.layout.spacing.ml) {
                    if let user = viewModel.user {
                        ProfileHeaderView(user: user, avatarImage: avatarImage)

                        userSetting(user: user)
                    }

                    appSettings

                    if appState.state.isAuthenticated {
                        logOutButton
                    }

                    Spacer()
                }
                .padding([.bottom, .leading, .trailing], theme.layout.spacing.m)
            }
        }
    }

    var logOutButton: some View {
        VStack {
            Button {
                viewModel.logout()
                router.pop()
            } label: {
                HStack {
                    Text(.logOut)
                        .font(theme.typography.body)
                        .tint(theme.colors.textPrimary)

                    Spacer()

                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .foregroundColor(theme.colors.textSecondary)
                }
                .padding(theme.layout.spacing.m)
            }
        }
        .applyGroupContainerStyle(theme)
    }

    var appSettings: some View {
        VStack {
            SettingsRowView(
                leftIcon: "globe",
                title: .language,
                localizedValue: appState.appLanguage.displayName,
                destination: .push(.languageSettings)
            )
            .bottomDivider([.leading, .trailing], theme.layout.spacing.m)

            SettingsRowView(
                leftIcon: appState.themeMode.systemIcon,
                title: .theme,
                localizedValue: appState.themeMode.displayName,
                destination: .push(.themeSettings)
            )
        }
        .applyGroupContainerStyle(theme)
    }

    func userSetting(user: User) -> some View {
        VStack {
            SettingsRowView(
                leftIcon: "person",
                title: .userProfile,
                destination: .push(.changeUserInfo(user: user))
            )
            .bottomDivider([.leading, .trailing], theme.layout.spacing.m)

            SettingsRowView(
                leftIcon: "bell",
                title: .notification,
                value: appState.notificationLeadTime.displayName(locale: locale),
                destination: .push(.notificationSettings)
            )
            // TODO: implement when it will be possible
//            SettingsRowView(
//                leftIcon: "lock",
//                title: .changePassword,
//                destination: .push(.changePassword)
//            )
        }
        .applyGroupContainerStyle(theme)
    }
}

#Preview {
    let router: Router = .previewRouter()
    NavigationContainer(parentRouter: router) {
        ZStack {
            BackgroundView()
            SettingsView(viewModel: AppContainer.shared.viewModelsFactory.makePreviewSettingsViewModel())
        }
    }
    .setupPreviewEnvironments(.light, router)
}
