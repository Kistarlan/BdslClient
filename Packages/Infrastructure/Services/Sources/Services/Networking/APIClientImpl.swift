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
        var request = try await buildRequest(endpoint)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        if http.statusCode == 401 {
            _ = try await refreshActor.token {
                try await self.refreshToken()
            }

            request = try await buildRequest(endpoint)

            let (retryData, retryResponse) = try await URLSession.shared.data(for: request)

            guard let retryHttp = retryResponse as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }

            guard (200 ..< 300).contains(retryHttp.statusCode) else {
                throw APIError.http(retryHttp.statusCode)
            }

            return try JSONDecoder.apiDecoder.decode(T.self, from: retryData)
        }

        guard (200 ..< 300).contains(http.statusCode) else {
            throw APIError.http(http.statusCode)
        }

        return try JSONDecoder.apiDecoder.decode(T.self, from: data)
    }

    func ensureValidToken() async throws -> String? {
        try await validToken()
    }

    private func buildRequest(_ endpoint: Endpoint) async throws -> URLRequest {
        let token = try await validToken()

        var components = URLComponents(
            url: baseURL.appendingPathComponent(endpoint.path),
            resolvingAgainstBaseURL: false
        )!

        components.queryItems = endpoint.query.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }

        var request = URLRequest(url: components.url!)

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
