//
//  LoginViewModelTests.swift
//  BdslClientTests
//

import Testing
@testable import BdslClient

@MainActor
struct LoginViewModelTests {
    // MARK: - Helpers

    private func makeViewModel(
        authRepository: MockAuthRepository = MockAuthRepository()
    ) -> LoginViewModel {
        LoginViewModel(
            authRepository: authRepository,
            appState: AppStateFactory.make()
        )
    }

    // MARK: - Validation

    @Test("Empty phone fails validation and sets phoneError")
    func emptyPhone_setsPhoneError() {
        let vm = makeViewModel()
        vm.phone = ""

        let isValid = vm.validationInputs()

        #expect(!isValid)
        #expect(vm.phoneError != nil)
    }

    @Test("Phone with letters fails validation")
    func phoneWithLetters_setsPhoneError() {
        let vm = makeViewModel()
        vm.phone = "abc1234567"

        let isValid = vm.validationInputs()

        #expect(!isValid)
        #expect(vm.phoneError != nil)
    }

    @Test("Phone with fewer than 10 digits fails validation")
    func shortPhone_setsPhoneError() {
        let vm = makeViewModel()
        vm.phone = "050123"

        let isValid = vm.validationInputs()

        #expect(!isValid)
        #expect(vm.phoneError != nil)
    }

    @Test("Valid 10-digit phone starting with 0 passes validation")
    func validPhone_clearsPhoneError() {
        let vm = makeViewModel()
        vm.phone = "0501234567"

        let isValid = vm.validationInputs()

        #expect(isValid)
        #expect(vm.phoneError == nil)
    }

    // MARK: - Credentials

    @Test("getCredentials in password mode returns phonePassword")
    func getCredentials_passwordMode_returnsPhonePassword() {
        let vm = makeViewModel()
        vm.phone = "0501234567"
        vm.password = "secret"
        vm.loginByPassword = true

        let credentials = vm.getCredentials()

        if case let .phonePassword(phone, password) = credentials {
            #expect(phone == "0501234567")
            #expect(password == "secret")
        } else {
            Issue.record("Expected .phonePassword credentials")
        }
    }

    @Test("getCredentials in telegram mode returns telegram")
    func getCredentials_telegramMode_returnsTelegram() {
        let vm = makeViewModel()
        vm.phone = "0501234567"
        vm.loginByPassword = false

        let credentials = vm.getCredentials()

        if case let .telegram(phone) = credentials {
            #expect(phone == "0501234567")
        } else {
            Issue.record("Expected .telegram credentials")
        }
    }

    // MARK: - Reset

    @Test("reset() clears all fields and errors")
    func reset_clearsAllFields() {
        let vm = makeViewModel()
        vm.phone = "0501234567"
        vm.password = "secret"
        vm.loginError = .loginFailed
        _ = vm.validationInputs()

        vm.reset()

        #expect(vm.phone.isEmpty)
        #expect(vm.password.isEmpty)
        #expect(vm.loginError == nil)
        #expect(vm.phoneError == nil)
    }

    // MARK: - Toggle

    @Test("toggleLoginByPassword flips loginByPassword")
    func toggleLoginByPassword_flipsMode() {
        let vm = makeViewModel()
        let initial = vm.loginByPassword

        vm.toggleLoginByPassword()

        #expect(vm.loginByPassword == !initial)
    }

    // MARK: - Login flow

    @Test("login() with invalid phone does not call repository")
    func login_invalidPhone_doesNotCallRepository() async {
        let repo = MockAuthRepository()
        let vm = makeViewModel(authRepository: repo)
        vm.phone = "bad"

        vm.login()
        // Give the Task a chance to run (none expected)
        try? await Task.sleep(for: .milliseconds(50))

        #expect(repo.loginCallCount == 0)
    }

    @Test("login() with valid phone calls repository")
    func login_validPhone_callsRepository() async {
        let repo = MockAuthRepository()
        repo.loginResult = .failure(MockError.generic)
        let vm = makeViewModel(authRepository: repo)
        vm.phone = "0501234567"
        vm.password = "secret"
        vm.loginByPassword = true

        vm.login()
        try? await Task.sleep(for: .milliseconds(50))

        #expect(repo.loginCallCount == 1)
    }

    @Test("login() failure sets loginError")
    func login_failure_setsLoginError() async {
        let repo = MockAuthRepository()
        repo.loginResult = .failure(MockError.generic)
        let vm = makeViewModel(authRepository: repo)
        vm.phone = "0501234567"

        vm.login()
        try? await Task.sleep(for: .milliseconds(100))

        #expect(vm.loginError != nil)
        #expect(!vm.isLoading)
    }
}
