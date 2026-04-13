//
//  PreviewAuthRepository.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 26.01.2026.
//

import Foundation
import Models
import OSLog
import Services

final class PreviewAuthRepository: AuthRepository {
    private let tokenStore: TokenStore
    private let jwtDecoder: JwtDecoder
    private let previewJwtPayloadDTO: JwtPayloadDTO

    init(
        tokenStore: TokenStore,
        jwtDecoder: JwtDecoder,
        previewJwtPayloadDTO: JwtPayloadDTO
    ) {
        self.tokenStore = tokenStore
        self.jwtDecoder = jwtDecoder
        self.previewJwtPayloadDTO = previewJwtPayloadDTO
    }

    func login(with credentials: Credentials) async throws -> UserIdentifier {
        do {
            let token = try jwtDecoder.encode(previewJwtPayloadDTO)
            await tokenStore.save(tokenType: .jwt, token: token)

            let payload = try jwtDecoder.decode(token, as: JwtPayloadDTO.self)
            return payload.user.toDomain()
        } catch {
            Logger.current().log("Failed to decode preview JWT: \(error)")
            throw error
        }
    }

    func restoreSession() async -> UserIdentifier? {
        guard let token = await tokenStore.load(tokenType: .jwt) else { return nil }
        guard let payload = try? jwtDecoder.decode(token, as: JwtPayloadDTO.self) else { return nil }

        return payload.user.toDomain()
    }

    func isSessionExpired() async -> Bool {
        guard let token = await tokenStore.load(tokenType: .jwt) else { return true }
        guard let payload = try? jwtDecoder.decode(token, as: JwtPayloadDTO.self) else { return true }

        return payload.exp < Date().timeIntervalSince1970
    }

    func hasValidSession() async -> Bool {
        !(await isSessionExpired())
    }

    func logout() async {
        await tokenStore.clearAll()
    }

    func resetPasswordRequest(phone: String) async throws -> Models.ResetPasswordInviteKey {
        throw AuthRepositoryError.notImplemented("resetPasswordRequest")
    }

    func resetPassword(inviteKey: String, pin: Int, newPassword: String) async throws {
        throw AuthRepositoryError.notImplemented("resetPassword")
    }
}
