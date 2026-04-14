//
//  ResetPasswordViewModel.swift
//  BdslClient
//

import Foundation
import Models
import Services

@MainActor
@Observable
final class ResetPasswordViewModel {
    var pin = ""
    var newPassword = ""
    var confirmPassword = ""
    var isLoading = false
    var error: LocalizedStringResource?
    var isSuccess = false

    private let authRepository: AuthRepository
    private let inviteKey: ResetPasswordInviteKey

    init(authRepository: AuthRepository, inviteKey: ResetPasswordInviteKey) {
        self.authRepository = authRepository
        self.inviteKey = inviteKey
    }

    func resetPassword() async {
        error = nil
        guard validate() else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            try await authRepository.resetPassword(
                inviteKey: inviteKey.inviteKey,
                pin: Int(pin)!,
                newPassword: newPassword
            )
            isSuccess = true
        } catch {
            self.error = .resetPasswordFailed
        }
    }

    private func validate() -> Bool {
        guard pin.count == 6 else {
            error = .pinTooShort
            return false
        }
        guard newPassword.count >= 6 else {
            error = .passwordTooShort
            return false
        }
        guard newPassword == confirmPassword else {
            error = .passwordsDoNotMatch
            return false
        }
        return true
    }
}
