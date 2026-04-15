//
//  APIClientImpl.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 23.01.2026.
//

import Configs
import Foundation
import Models
import OSLog

final class APIClientImpl: APIClient {
    private let baseURL: URL = Config.baseURL
    private let tokenStore: TokenStore
    private let jwtDecoder: JwtDecoder
    private let refreshActor = TokenRefreshActor()

    init(
        tokenStore: TokenStore,
        jwtDecoder: JwtDecoder
    ) {
        self.tokenStore = tokenStore
        self.jwtDecoder = jwtDecoder
    }

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let data = try await performRequest(endpoint)
        return try JSONDecoder.apiDecoder.decode(T.self, from: data)
    }

    func request(_ endpoint: Endpoint) async throws {
        _ = try await performRequest(endpoint)
    }

    func ensureValidToken() async throws -> String? {
        try await validToken()
    }

    // MARK: - Private helpers

    /// Builds, executes, and retries (on 401) a request, returning raw response data.
    private func performRequest(_ endpoint: Endpoint) async throws -> Data {
        let request = try await buildRequest(endpoint)
        do {
            return try await execute(request)
        } catch APIError.http(401) {
            _ = try await refreshActor.token { try await self.refreshToken() }
            let retryRequest = try await buildRequest(endpoint)
            return try await execute(retryRequest)
        }
    }

    @discardableResult
    private func execute(_ request: URLRequest) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard (200 ..< 300).contains(http.statusCode) else {
            throw APIError.http(http.statusCode)
        }
        return data
    }

    private func buildRequest(_ endpoint: Endpoint) async throws -> URLRequest {
        let token = try await validToken()

        guard var components = URLComponents(
            url: baseURL.appendingPathComponent(endpoint.path),
            resolvingAgainstBaseURL: false
        ) else {
            throw URLError(.badURL)
        }

        if !endpoint.query.isEmpty {
            components.queryItems = endpoint.query.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }

        guard let url = components.url else { throw URLError(.badURL) }
        var request = URLRequest(url: url)

        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        for header in endpoint.headers {
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }

        if let token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return request
    }

    private func validToken() async throws -> String? {
        guard let jwt = await tokenStore.load(tokenType: .jwt),
              let payload = try? jwtDecoder.decode(jwt, as: JwtPayloadDTO.self)
        else {
            return nil
        }

        let now = Date().timeIntervalSince1970

        if payload.exp - now > 60 {
            return jwt
        }

        return try await refreshActor.token {
            try await self.refreshToken()
        }
    }

    private func refreshToken() async throws -> String {
        guard let refreshToken = await tokenStore.load(tokenType: .refresh) else {
            throw APIError.incorrectRefreshToken
        }

        let body = try JSONEncoder().encode([
            "refreshToken": refreshToken
        ])

        var request = URLRequest(
            url: baseURL.appendingPathComponent("/auth/refreshToken")
        )

        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse,
              (200 ..< 300).contains(http.statusCode)
        else {
            throw APIError.http((response as? HTTPURLResponse)?.statusCode ?? 500)
        }

        let session = try JSONDecoder.apiDecoder.decode(SessionDTO.self, from: data)

        await tokenStore.save(tokenType: .jwt, token: session.authToken)
        await tokenStore.save(tokenType: .refresh, token: session.refreshToken)

        return session.authToken
    }
}
