//
//  AppState.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 23.01.2026.
//

import Combine
import Foundation
import SwiftUI
import Models
import DesignSystem
import Services

@MainActor
final class AppState: ObservableObject {
    private static let themeModeKey = "themeMode"
    private static let languageKey = "language"
    private let authRepository: AuthRepository
    private let cachingManager: CachingManager
    private let usersService: UsersService
    private var userDefaults: UserDefaults = .standard

    @Published private(set) var state: AppFlowState = .splash
    @Published var themeMode: ThemeMode {
        didSet {
            guard oldValue != themeMode else { return }
            userDefaults.set(themeMode.rawValue, forKey: AppState.themeModeKey)
        }
    }

    @Published var appLanguage: AppLanguage {
        didSet {
            guard oldValue != appLanguage else { return }
            userDefaults.set(appLanguage.rawValue, forKey: AppState.languageKey)
        }
    }

    init(authRepository: AuthRepository,
         usersService: UsersService,
         cachingManager: CachingManager) {
        self.authRepository = authRepository
        self.usersService = usersService
        self.cachingManager = cachingManager

        if let raw = userDefaults.string(forKey: AppState.themeModeKey),
           let saved = ThemeMode(rawValue: raw)
        {
            themeMode = saved
        } else {
            themeMode = .system
        }

        if let raw = userDefaults.string(forKey: AppState.languageKey),
           let saved = AppLanguage(rawValue: raw)
        {
            appLanguage = saved
        } else {
            appLanguage = .system
        }
    }

    func bootstrap() {
        Task {
            let authState = await restoreSession()

            switch authState {
            case let .authenticated(user):
                state = .authenticated(user)
            case .unauthenticated, .expired, .undefined:
                state = .unauthenticated
            }
        }
    }

    func restoreSession() async -> AuthState {
        guard await authRepository.hasValidSession() else {
            return .expired
        }
        
        if let userIdentifier = await authRepository.restoreSession(),
           let user = await loadUserInfo(userIdentifier: userIdentifier) {
            return .authenticated(user)
        }
        
        return .unauthenticated
    }

    private func loadUserInfo(userIdentifier: UserIdentifier) async -> User? {
        do {
            let user = try await usersService.fetchUserInfo(for: userIdentifier.id)

            return user
        } catch {
            return nil
        }
    }

    func logout() async {
        state = .unauthenticated
        await authRepository.logout()
        await cachingManager.clearUserCache()
    }

    func onLoginSuccess(user: UserIdentifier) async throws {
        if let user = await loadUserInfo(userIdentifier: user) {
            updateUser(newUser: user)
        }
    }

    func updateUser(newUser: User) {
        state = .authenticated(newUser)
    }
}

extension AppState {
    func resolveTheme(systemScheme: ColorScheme) -> any AppTheme {
        switch themeMode {
        case .system:
            return systemScheme == .dark ? DarkTheme() : LightTheme()
        case .dark:
            return DarkTheme()
        case .light:
            return LightTheme()
        }
    }
}
