//
//  UsersRepository.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 04.02.2026.
//

import Models

public protocol UsersRepository: Sendable {
    func fetchUsersInfo(for ids: [String]) async throws -> [UserDTO]
    func fetchUserInfo(for id: String) async throws -> UserDTO
    func updateUserInfo(_ user: User) async throws -> UserDTO
}
