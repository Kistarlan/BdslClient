//
//  SubscriptionsRepositoryImpl.swift
//  Services
//
//  Created by Oleh Rozkvas on 20.04.2026.
//

import Models

final class SubscriptionsRepositoryImpl: SubscriptionsRepository {
    let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func fetchSettings() async throws -> [SettingDTO] {
        let endpoint = Endpoint(
            path: "/settings",
            method: .get
        )

        return try await apiClient.request(endpoint)
    }
}
