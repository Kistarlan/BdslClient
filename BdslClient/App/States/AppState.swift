//
//  AppState.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 23.01.2026.
//

import Combine
import DesignSystem
import Foundation
import Models
import Services
import SwiftUI

@MainActor
final class AppState: ObservableObject {
    private let authRepository: AuthRepository
    private let cachingManager: CachingManager
    private let usersService: UsersService
    private let networkState: NetworkState
    private var userDefaults: UserDefaults = .standard
    private var cancellables = Set<AnyCancellable>()
    private var isBootstrapping: Bool = false
    private var settings: AppSettings

    @Published private(set) var state: AppFlowState = .splash
    @Published var isNetworkAvailable: Bool
    @Published var themeMode: ThemeMode {
        didSet {
            guard oldValue != themeMode else { return }
            settings.themeMode = themeMode
        }
    }

    @Published var appLanguage: AppLanguage {
        didSet {
            guard oldValue != appLanguage else { return }
            settings.appLanguage = appLanguage
        }
    }

    @Published var notificationLeadTime: NotificationLeadTime {
        didSet {
            guard oldValue != notificationLeadTime else { return }
            settings.notificationLeadTime = notificationLeadTime
        }
    }

    init(
        authRepository: AuthRepository,
        usersService: UsersService,
        cachingManager: CachingManager,
        networkState: NetworkState,
        appSettings: AppSettings
    ) {
        self.authRepository = authRepository
        self.usersService = usersService
        self.cachingManager = cachingManager
        settings = appSettings
        self.networkState = networkState
        themeMode = settings.themeMode
        appLanguage = settings.appLanguage
        notificationLeadTime = settings.notificationLeadTime

        isNetworkAvailable = networkState.isConnected

        subscribeToEvents()
    }

    func subscribeToEvents() {
        networkState.$isConnected
            .sink { [weak self] connected in
                guard self != nil,
                      self?.isNetworkAvailable != connected else { return }

                self!.isNetworkAvailable = connected
                if !self!.state.isAuthenticated {
                    self!.bootstrap()
                }
            }
            .store(in: &cancellables)
    }

    func bootstrap() {
        if isBootstrapping {
            return
        } else {
            isBootstrapping = true
        }

        Task {
            let authState = await restoreSession()

            switch authState {
            case let .authenticated(user):
                state = .authenticated(user)
            case .unauthenticated, .expired, .undefined:
                state = .unauthenticated
            }

            isBootstrapping = false
        }
    }

    func restoreSession() async -> AuthState {
        guard await authRepository.hasValidSession() else {
            return .expired
        }

        if let userIdentifier = await authRepository.restoreSession(),
           let user = await loadUserInfo(userIdentifier: userIdentifier)
        {
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
