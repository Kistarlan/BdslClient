//
//  LocationsRepositoryImpl.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 25.02.2026.
//
import Models

final class LocationsRepositoryImpl: LocationsRepository {
    let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func fetchLocations() async throws -> [LocationDTO] {
        let endpoint = Endpoint(
            path: "/locations",
            method: .get
        )

        return try await apiClient.request(endpoint)
    }
}
