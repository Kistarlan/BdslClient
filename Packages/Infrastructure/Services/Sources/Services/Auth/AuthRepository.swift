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
}
