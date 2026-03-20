//
//  GroupsRepositoryImpl.swift
//  Services
//
//  Created by Oleh Rozkvas on 19.03.2026.
//

import Models

final class GroupsRepositoryImpl : GroupsRepository {

    let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func fetchGroups() async throws -> [GroupDTO] {
        let endpoint = Endpoint(
            path: "/calendar/groups",
            method: .get,
        )

        return try await apiClient.request(endpoint)
    }
}
