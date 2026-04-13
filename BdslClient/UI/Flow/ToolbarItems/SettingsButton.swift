//
//  SettingsButton.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 06.03.2026.
//

import DesignSystem
import Models
import Navigation
import Services
import SwiftUI

struct SettingsButton: View {
    @Environment(\.theme) private var theme
    @Environment(AppState.self) private var appState
    @State private var avatarImage: UIImage?

    private let imageService = AppContainer.shared.services.imageService

    var body: some View {
        NavigationButton(push: PushDestination.settings) {
            settingsImage
        }
        .task {
            if case let .authenticated(user) = appState.state,
               let avatar = user.avatar
            {
                await loadAvatarImage(imageSource: avatar.small)
            }
        }
    }

    func image() -> Image {
        if let image = avatarImage {
            Image(uiImage: image)
        } else {
            Image(systemName: "person.crop.circle.fill")
        }
    }
}

extension SettingsButton {
    var settingsImage: some View {
        image()
            .resizable()
            .frame(width: 36, height: 36)
            .foregroundStyle(theme.colors.iconSecondary)
            .clipShape(Circle())
    }

    func loadAvatarImage(imageSource: String) async {
        do {
            let avatarData = try await imageService.fetchImage(imageSource)

            avatarImage = UIImage(data: avatarData)
        } catch {
            avatarImage = nil
        }
    }
}
