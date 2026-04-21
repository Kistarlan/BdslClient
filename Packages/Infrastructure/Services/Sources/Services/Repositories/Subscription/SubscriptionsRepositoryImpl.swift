//
//  SubscriptionsRepositoryImpl.swift
//  Services
//
//  Created by Oleh Rozkvas on 20.04.2026.
//

import Models
import Foundation

final class SubscriptionsRepositoryImpl: SubscriptionsRepository {
    let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func fetchSettings() async throws -> SubscriptionSettings {
        let endpoint = Endpoint(
            path: "/settings",
            method: .get
        )

        let dtos: [SettingDTO] = try await apiClient.request(endpoint)
        return dtos.toDomain()
    }

    func requestOrder(requestModel: OrderRequestDTO) async throws -> OrderResponseDTO {
        let endpoint = Endpoint(
            path: "/orders",
            method: .post,
            body: try JSONEncoder().encode(requestModel)
        )

        return try await apiClient.request(endpoint)
    }
}

