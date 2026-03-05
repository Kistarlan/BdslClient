//
//  SettingsButton.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 06.03.2026.
//

import SwiftUI
import Navigation
import DesignSystem
import Models
import Services

struct SettingsButton: View {
    @Environment(\.theme) private var theme
    @EnvironmentObject private var appState: AppState
    @State var avatarImage: UIImage?

    private let imageSerbvice = AppContainer.shared.services.imageService

    var body: some View {
        NavigationButton(push: PushDestination.settings){
            image()
                .resizable()
                .frame(width: 36, height: 36)
                .foregroundColor(theme.colors.iconSecondary)
                .clipShape(Circle())
        }
        .onAppear {
            if case let .authenticated(user) = appState.state,
               let avatar = user.avatar {
                Task {
                    await loadAvatarImage(imageSource: avatar.small)
                }
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
    func loadAvatarImage(imageSource: String) async {
        do {
            let avatarData = try await imageSerbvice.fetchImage(imageSource)

            avatarImage = UIImage(data: avatarData)
        } catch {
            avatarImage = nil
        }
    }
}
