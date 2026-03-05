//
//  UsersService.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 25.02.2026.
//

import Models

public protocol UsersService : Sendable {
    func fetchUserInfo(for id: String) async throws -> User
    func fetchUsersInfo(for ids: [String]) async throws -> [User]
    func updateUserInfo(_ user: User) async throws -> User
}
