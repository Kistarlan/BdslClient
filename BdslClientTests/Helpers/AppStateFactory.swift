//
//  AppStateFactory.swift
//  BdslClientTests
//

import Models
import Services
@testable import BdslClient

/// Builds a real AppState instance wired to mock dependencies, for use in unit tests.
@MainActor
enum AppStateFactory {
    static func make(
        authRepository: any AuthRepository = MockAuthRepository(),
        usersService: any UsersService = MockUsersService(),
        notificationLeadTime: NotificationLeadTime = .disabled,
        flowState: AppFlowState = .unauthenticated,
        networkAvailable: Bool = true
    ) -> AppState {
        let settings = MockAppSettings(notificationLeadTime: notificationLeadTime)
        let networkMonitor = NetworkMonitor()
        let networkState = NetworkState(monitor: networkMonitor)
        let appState = AppState(
            authRepository: authRepository,
            usersService: usersService,
            cachingManager: MockCachingManager(),
            networkState: networkState,
            appSettings: settings,
            notificationManager: MockNotificationManager(),
            permissionService: MockPermissionService()
        )

        // Pre-set desired flow state without going through async bootstrap
        switch flowState {
        case let .authenticated(user):
            appState.updateUser(newUser: user)
        case .unauthenticated:
            break
        default:
            break
        }

        appState.isNetworkAvailable = networkAvailable
        return appState
    }

    static func makeUser(
        id: String = "user-1",
        name: String = "Test",
        surname: String? = "User",
        phone: String? = "+380501234567",
        email: String? = "test@example.com"
    ) -> User {
        User(
            id: id,
            fullName: "\(name) \(surname ?? "")",
            role: .student,
            name: name,
            surname: surname,
            contacts: Contact(id: "contact-1", phone: phone, email: email),
            avatar: nil
        )
    }
}
