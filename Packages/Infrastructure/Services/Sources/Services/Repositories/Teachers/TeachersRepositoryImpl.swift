//
//  TeachersRepositoryImpl.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 25.02.2026.
//

import Models

final class TeachersRepositoryImpl: TeachersRepository {

    let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func fetchTeachers() async throws -> [TeacherDTO] {
        let endpoint = Endpoint(
            path: "/teachers",
            method: .get
        )

        return try await apiClient.request(endpoint)
    }
}
