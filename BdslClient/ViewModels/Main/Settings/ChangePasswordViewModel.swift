//
//  ChangePasswordViewModel.swift
//  BdslClient
//

import Foundation
import Models
import Services

@MainActor
@Observable
final class ChangePasswordViewModel {
    var currentPassword = ""
    var newPassword = ""
    var confirmPassword = ""
    var isLoading = false
    var error: LocalizedStringResource?
    var isSuccess = false

    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    func changePassword() async {
        error = nil
        guard validate() else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            try await authRepository.changePassword(
                oldPassword: currentPassword,
                newPassword: newPassword
            )
            isSuccess = true
        } catch APIError.http(422) {
            error = .passwordNotSet
        } catch {
            self.error = .changePasswordFailed
        }
    }

    private func validate() -> Bool {
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
