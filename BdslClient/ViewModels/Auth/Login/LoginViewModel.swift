//
//  LoginViewModel.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 23.01.2026.
//

import Combine
import Foundation
import Models
import Services

@MainActor
@Observable
final class LoginViewModel {
    var phone = ""
    var phoneError: LocalizedStringResource?
    var password = ""
    var isLoading = false
    var loginByPassword = false
    var loginError: LocalizedStringResource?

    private let authRepository: AuthRepository
    private let appState: AppState

    init(
        authRepository: AuthRepository,
        appState: AppState
    ) {
        self.authRepository = authRepository
        self.appState = appState
    }

    func login() {
        loginError = nil

        guard validationInputs() else {
            return
        }

        isLoading = true

        Task {
            do {
                let identifier = try await authRepository.login(with: getCredentials())
                try await appState.onLoginSuccess(user: identifier)
            } catch {
                self.loginError = .loginFailed
            }

            isLoading = false
        }
    }

    func validationInputs() -> Bool {
        if !phone.isValidPhone {
            phoneError = .pleaseEnterValidPhoneNumber
        } else {
            phoneError = nil
        }

        return phoneError == nil
    }

    func getCredentials() -> Credentials {
        if loginByPassword {
            .phonePassword(phone: phone, password: password)
        } else {
            .telegram(phone: phone)
        }
    }

    func reset() {
        phone = ""
        password = ""
        loginError = nil
        phoneError = nil
    }
}
