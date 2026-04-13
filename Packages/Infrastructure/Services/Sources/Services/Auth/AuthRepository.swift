//
//  AuthRepository.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 23.01.2026.
//

import Models

public protocol AuthRepository: Sendable {
    func login(with credentials: Credentials) async throws -> UserIdentifier
    func restoreSession() async -> UserIdentifier?
    func logout() async
    func hasValidSession() async -> Bool

    func resetPasswordRequest(phone: String, channel: ResetPasswordChannel) async throws -> ResetPasswordInviteKey
    func resetPassword(inviteKey: String, pin: Int, newPassword: String) async throws
}
