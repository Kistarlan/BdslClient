//
//  UsersRepositoryImpl.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 04.02.2026.
//

import Foundation
import Models
import MongoFilters

final class UsersRepositoryImpl: UsersRepository {
    let apiClient: APIClient
    let tokenStore: TokenStore

    init(apiClient: APIClient, tokenStore: TokenStore) {
        self.apiClient = apiClient
        self.tokenStore = tokenStore
    }

    func fetchUserInfo(for id: String) async throws -> UserDTO {
        let endpoint = Endpoint(
            path: "/users/\(id)",
            method: .get
        )

        return try await apiClient.request(endpoint)
    }

    func fetchUsersInfo(for ids: [String]) async throws -> [UserDTO] {
        let filter = Filter.In("_id", ids)
        let filterString = try filter.makeFilterQuery()

        let endpoint = Endpoint(
            path: "/users",
            method: .get,
            query: [
                "filter": filterString
            ]
        )

        return try await apiClient.request(endpoint)
    }

    func updateUserInfo(_ user: User) async throws -> UserDTO {
        let updateUserDTO = UpdateUserDTO(
            name: user.name,
            surname: user.surname ?? "",
            role: UserRole.student.rawValue,
            contacts: ContactDTO(
                _id: user.contacts.id,
                phone: user.contacts.phone,
                telegram: user.contacts.telegram,
                email: user.contacts.email
            ),
            avatar: nil
        )

        let endpoint = try Endpoint(
            path: "/users/\(user.id)",
            method: .put,
            body: JSONEncoder().encode(updateUserDTO)
        )

        return try await apiClient.request(endpoint)
    }
}
