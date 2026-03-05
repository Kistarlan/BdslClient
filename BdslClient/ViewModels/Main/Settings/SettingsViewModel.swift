//
//  SettingsViewModel.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 04.02.2026.
//

import Combine
import Foundation
import OSLog
import SwiftUI
import Models
import Services

@MainActor
@Observable
final class SettingsViewModel {
    var user: User?
    var avatarData: Data?
    let logger = Logger.forCategory(String(describing: SettingsViewModel.self))

    private let usersService: UsersService
    private let appState: AppState
    private let imageService: ImageService

    init(
        usersService: UsersService,
        appState: AppState,
        imageService: ImageService
    ) {
        self.usersService = usersService
        self.appState = appState
        self.imageService = imageService
    }

    func onAppear() {
        guard case let .authenticated(cachedUser) = appState.state else {
            return
        }

        updateUser(cachedUser)
    }


    func updateUser(_ user: User) {
        self.user = user
        if let avatar = user.avatar {
            Task {
                do {
                    avatarData = try await self.imageService.fetchImage(avatar.medium)
                } catch {
                    logger.warning("Can't load avatar for \(avatar.id)")
                }
            }
        }
    }

    func logout() {
        user = nil
        Task {
            await appState.logout()
        }
    }
}
