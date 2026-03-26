//
//  UsersServiceImpl.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 25.02.2026.
//

import Models

final class UsersServiceImpl: UsersService {
    private let usersRepository: UsersRepository

    init(usersRepository: UsersRepository) {
        self.usersRepository = usersRepository
    }

    func fetchUsersInfo(for ids: [String]) async throws -> [User] {
        let dtos = try await usersRepository.fetchUsersInfo(for: ids)

        return dtos.map { $0.toDomain() }
    }

    func fetchUserInfo(for id: String) async throws -> User {
        let dto = try await usersRepository.fetchUserInfo(for: id)

        return dto.toDomain()
    }

    func updateUserInfo(_ user: User) async throws -> User {
        let dto = try await usersRepository.updateUserInfo(user)

        return dto.toDomain()
    }
}
