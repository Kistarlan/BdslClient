//
//  MockAuthRepository.swift
//  BdslClientTests
//

import Foundation
import Models
import Services

final class MockAuthRepository: AuthRepository, @unchecked Sendable {
    // MARK: - Control

    var loginResult: Result<UserIdentifier, Error> = .failure(MockError.notConfigured)
    var resetPasswordRequestResult: Result<ResetPasswordInviteKey, Error> = .failure(MockError.notConfigured)
    var resetPasswordResult: Result<Void, Error> = .success(())
    var hasValidSessionValue = false

    // MARK: - Call tracking

    private(set) var loginCallCount = 0
    private(set) var lastLoginCredentials: Credentials?
    private(set) var resetPasswordRequestCallCount = 0
    private(set) var lastResetRequestPhone: String?
    private(set) var resetPasswordCallCount = 0
    private(set) var lastResetPasswordPin: Int?

    // MARK: - AuthRepository

    func login(with credentials: Credentials) async throws -> UserIdentifier {
        loginCallCount += 1
        lastLoginCredentials = credentials
        return try loginResult.get()
    }

    func restoreSession() async -> UserIdentifier? { nil }
    func logout() async {}
    func hasValidSession() async -> Bool { hasValidSessionValue }

    func resetPasswordRequest(phone: String, channel: ResetPasswordChannel) async throws -> ResetPasswordInviteKey {
        resetPasswordRequestCallCount += 1
        lastResetRequestPhone = phone
        return try resetPasswordRequestResult.get()
    }

    func resetPassword(inviteKey: String, pin: Int, newPassword: String) async throws {
        resetPasswordCallCount += 1
        lastResetPasswordPin = pin
        try resetPasswordResult.get()
    }
}

enum MockError: Error {
    case notConfigured
    case generic
}
