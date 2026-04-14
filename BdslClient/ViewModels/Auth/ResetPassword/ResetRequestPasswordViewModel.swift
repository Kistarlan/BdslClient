//
//  ResetRequestPasswordViewModel.swift
//  BdslClient
//

import Foundation
import Models
import Services

@MainActor
@Observable
final class ResetRequestPasswordViewModel {
    var phone = ""
    var phoneError: LocalizedStringResource?
    var isLoading = false
    var error: LocalizedStringResource?

    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    func requestReset() async -> ResetPasswordInviteKey? {
        error = nil
        guard validatePhone() else { return nil }

        isLoading = true
        defer { isLoading = false }

        do {
            let inviteKey = try await authRepository.resetPasswordRequest(
                phone: phone,
                channel: .telegramBot
            )
            return inviteKey
        } catch {
            self.error = .resetPasswordRequestFailed
            return nil
        }
    }

    private func validatePhone() -> Bool {
        if phone.isValidPhone {
            phoneError = nil
            return true
        } else {
            phoneError = .pleaseEnterValidPhoneNumber
            return false
        }
    }
}
