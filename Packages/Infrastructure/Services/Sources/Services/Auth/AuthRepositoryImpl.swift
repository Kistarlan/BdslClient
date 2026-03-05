//
//  AuthRepositoryImpl.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 23.01.2026.
//

import Foundation
import Models
import OSLog
import Configs

public final class AuthRepositoryImpl: AuthRepository {
    private let baseUrl = Config.baseURL
    private let apiClient: APIClient
    private let tokenStore: TokenStore
    private let jwtDecoder: JwtDecoder
    private let sseClient: SSEClient

    init(apiClient: APIClient,
         tokenStore: TokenStore,
         jwtDecoder: JwtDecoder,
         sseClient: SSEClient) {
        self.apiClient = apiClient
        self.tokenStore = tokenStore
        self.jwtDecoder = jwtDecoder
        self.sseClient = sseClient
    }

    public func login(with credentials: Credentials) async throws -> UserIdentifier {
        switch credentials {
        case .telegram:
            try await loginViaTelegram(credentials: credentials)
        default:
            throw AuthRepositoryError.notImplemented(credentials)
        }
    }

    public func restoreSession() async -> UserIdentifier? {
        guard let token = await tokenStore.load(tokenType: .jwt) else { return nil }
        guard let payload = try? jwtDecoder.decode(token, as: JwtPayloadDTO.self) else { return nil }

        return payload.user.toDomain()
    }

    public func hasValidSession() async -> Bool {
        (try? await apiClient.ensureValidToken()) != nil
    }

    public func logout() async {
        await tokenStore.clearAll()
    }
}

extension AuthRepositoryImpl {

    func loginViaTelegram(credentials: Credentials) async throws -> UserIdentifier {
        do {
            let sessionId = try await startTelegramLogin(credentials: credentials)

            let userIdentifier = try await waitForTelegramApproval(sessionId: sessionId)

            return userIdentifier
        } catch {
            throw error
        }
    }

    func waitForTelegramApproval(sessionId: String) async throws -> UserIdentifier {
        let url = baseUrl.appending(path: "/eventsSource/auth/\(sessionId)")

        for try await event in sseClient.events(from: url, as: AuthSSEResponseDTO.self) {
            guard event.approved, let session = event.session else {
                continue
            }

            await tokenStore.save(tokenType: .jwt, token: session.authToken)
            await tokenStore.save(tokenType: .refresh, token: session.refreshToken)

            let payload = try jwtDecoder.decode(
                session.authToken,
                as: JwtPayloadDTO.self
            )

            return payload.user.toDomain()
        }

        throw AuthRepositoryError.sessionExpired
    }

    func startTelegramLogin(credentials: Credentials) async throws -> String {
        let endpoint = Endpoint(
            path: "/auth/loginViaTgBot",
            method: .post,
            headers: ["Content-Type": "application/json"],
            body: try? JSONEncoder().encode(credentials)
        )

        let response: LoginViaTelegramResponseDTO = try await apiClient.request(endpoint)

        return response.session
    }
}

enum AuthRepositoryError : Error {
    case notImplemented(Credentials)
    case sessionExpired
}
