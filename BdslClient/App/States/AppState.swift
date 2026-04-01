//
//  AppState.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 23.01.2026.
//

import DesignSystem
import Foundation
import Models
import Services
import SwiftUI

@MainActor
@Observable
final class AppState {
    private let authRepository: AuthRepository
    private let cachingManager: CachingManager
    private let usersService: UsersService
    private let networkState: NetworkState
    private let notificationManager: NotificationManager
    private let permissionService: PermissionService
    private var isBootstrapping: Bool = false
    private var appSettings: AppSettings

    private(set) var state: AppFlowState = .splash
    var isNetworkAvailable: Bool = true {
        didSet {
            guard oldValue != isNetworkAvailable else { return }
            if !state.isAuthenticated {
                bootstrap()
            }
        }
    }
    var themeMode: ThemeMode {
        didSet { appSettings.themeMode = themeMode }
    }
    var appLanguage: AppLanguage {
        didSet { appSettings.appLanguage = appLanguage }
    }
    var notificationLeadTime: NotificationLeadTime {
        didSet { Task { await updateNotificationSettings(notificationLeadTime) } }
    }

    init(
        authRepository: AuthRepository,
        usersService: UsersService,
        cachingManager: CachingManager,
        networkState: NetworkState,
        appSettings: AppSettings,
        notificationManager: NotificationManager,
        permissionService: PermissionService
    ) {
        self.authRepository = authRepository
        self.usersService = usersService
        self.cachingManager = cachingManager
        self.appSettings = appSettings
        self.networkState = networkState
        self.notificationManager = notificationManager
        self.permissionService = permissionService
        themeMode = appSettings.themeMode
        appLanguage = appSettings.appLanguage
        notificationLeadTime = appSettings.notificationLeadTime

        isNetworkAvailable = networkState.isConnected

        subscribeToEvents()
    }

    func updateNotificationSettings(_ leadTime: NotificationLeadTime) async {
        notificationLeadTime = leadTime

        await initOrUpdateNotifications()
    }

    func initOrUpdateNotifications() async {
        let isNotificationsGranted = await permissionService.isNotificationPermissionGranted()

        if !isNotificationsGranted {
            return
        }

        if case let .authenticated(user) = state {
            try? await notificationManager.initOrUpdateNotifications(for: user.id)
        }
    }

    func subscribeToEvents() {
        // Start a task that watches for changes in networkState.isConnected
        Task { [weak self] in
            guard let self else { return }
            // Polling-free observation using withObservationTracking
            while true {
                await withTaskCancellationHandler {
                    await withCheckedContinuation { continuation in
                        withObservationTracking {
                            _ = self.networkState.isConnected
                        } onChange: {
                            continuation.resume()
                        }
                    }
                } onCancel: {}
                // Apply changes after a change is detected
                self.isNetworkAvailable = self.networkState.isConnected
            }
        }
    }

    func bootstrap() {
        if isBootstrapping {
            return
        } else {
            isBootstrapping = true
        }

        Task {
            let authState = await restoreSession()

            await handleState(authState)

            isBootstrapping = false
        }
    }

    private func handleState(_ authState: AuthState) async {
        switch authState {
        case let .authenticated(user):
            state = .authenticated(user)

            await initOrUpdateNotifications()
        case .unauthenticated, .expired, .undefined:
            state = .unauthenticated

            try? await notificationManager.cancelAll()
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
