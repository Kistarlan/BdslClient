//
//  ImageRepositoryImpl.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 18.02.2026.
//

import Foundation
import Models

final class ImageRepositoryImpl: ImageRepository {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func fetchImage(_ uri: String) async throws -> Data {
        let endpoint = Endpoint(
            path: uri,
            method: .get
        )

        return try await apiClient.request(endpoint)
    }

    func uploadImage(_ data: Data) async throws -> AvatarDTO {
        let boundary = "Boundary-\(UUID().uuidString)"

        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(data)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        let headers = ["Content-Type": "multipart/form-data; boundary=\(boundary)"]

        let endpoint = Endpoint(
            path: "/upload-image",
            method: .post,
            headers: headers,
            body: body
        )

        return try await apiClient.request(endpoint)
    }
}
