//
//  MockUsersService.swift
//  BdslClientTests
//

import Models
import Services

final class MockUsersService: UsersService, @unchecked Sendable {
    var fetchUserInfoResult: Result<User, Error> = .failure(MockError.notConfigured)

    func fetchUserInfo(for id: String) async throws -> User {
        try fetchUserInfoResult.get()
    }

    func fetchUsersInfo(for ids: [String]) async throws -> [User] { [] }

    func updateUserInfo(_ user: User) async throws -> User {
        user
    }
}
