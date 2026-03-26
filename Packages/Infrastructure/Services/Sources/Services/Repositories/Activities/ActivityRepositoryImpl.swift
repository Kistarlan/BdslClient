//
//  ActivityRepositoryImpl.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 25.02.2026.
//
import Models

final class ActivityRepositoryImpl: ActivityRepository {
    let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func fetchActivities() async throws -> [ActivityDTO] {
        let endpoint = Endpoint(
            path: "/activities",
            method: .get
        )

        return try await apiClient.request(endpoint)
    }
}
