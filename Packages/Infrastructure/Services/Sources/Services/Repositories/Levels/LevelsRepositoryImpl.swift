//
//  LevelsRepositoryImpl.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 25.02.2026.
//

import Models

final class LevelsRepositoryImpl: LevelsRepository {

    let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func fetchLevels() async throws -> [LevelDTO] {
        let endpoint = Endpoint(
            path: "/levels",
            method: .get
        )

        return try await apiClient.request(endpoint)
    }
}
