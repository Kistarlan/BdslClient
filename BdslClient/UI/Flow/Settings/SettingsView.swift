//
//  SettingsView.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 03.02.2026.
//

import SwiftUI
import Models
import DesignSystem
import Navigation

struct SettingsView: View {
    @Environment(\.theme) private var theme
    @EnvironmentObject private var appState: AppState
    @Bindable var viewModel: SettingsViewModel
    @Environment(Router.self) private var router

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
                    } else {
                        loginButton
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

    var loginButton: some View {
        VStack {
            SettingsRowView(
                title: .login,
                rightIcon: "person.crop.circle",
                destination: .push(.login)
            )
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

            getDivider()

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

            getDivider()

//TODO: implement when it will be possible
//            SettingsRowView(
//                leftIcon: "lock",
//                title: .changePassword,
//                destination: .push(.changePassword)
//            )
        }
        .applyGroupContainerStyle(theme)
    }

    func getDivider() -> some View {
        Divider()
            .background(theme.colors.divider)
            .frame(height: 1)
            .padding(.leading, theme.layout.spacing.m)
            .padding(.trailing, theme.layout.spacing.m)
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
