//
//  ResetPasswordViewModelTests.swift
//  BdslClientTests
//

import Testing
import Models
@testable import BdslClient

@MainActor
struct ResetPasswordViewModelTests {
    private let inviteKey = ResetPasswordInviteKey(inviteKey: "test-key")

    private func makeViewModel(
        authRepository: MockAuthRepository = MockAuthRepository()
    ) -> ResetPasswordViewModel {
        ResetPasswordViewModel(
            authRepository: authRepository,
            inviteKey: inviteKey
        )
    }

    // MARK: - PIN validation

    @Test("Pin shorter than 6 digits sets pinTooShort error")
    func shortPin_setsPinError() async {
        let vm = makeViewModel()
        vm.pin = "123"
        vm.newPassword = "password1"
        vm.confirmPassword = "password1"

        await vm.resetPassword()

        #expect(vm.error != nil)
        #expect(!vm.isSuccess)
    }

    @Test("Pin longer than 6 digits sets pinTooShort error")
    func longPin_setsPinError() async {
        let vm = makeViewModel()
        vm.pin = "1234567"
        vm.newPassword = "password1"
        vm.confirmPassword = "password1"

        await vm.resetPassword()

        #expect(vm.error != nil)
        #expect(!vm.isSuccess)
    }

    // MARK: - Password validation

    @Test("Password shorter than 6 chars sets passwordTooShort error")
    func shortPassword_setsPasswordError() async {
        let vm = makeViewModel()
        vm.pin = "123456"
        vm.newPassword = "abc"
        vm.confirmPassword = "abc"

        await vm.resetPassword()

        #expect(vm.error != nil)
        #expect(!vm.isSuccess)
    }

    @Test("Mismatched passwords set passwordsDoNotMatch error")
    func mismatchedPasswords_setsMatchError() async {
        let vm = makeViewModel()
        vm.pin = "123456"
        vm.newPassword = "password1"
        vm.confirmPassword = "different1"

        await vm.resetPassword()

        #expect(vm.error != nil)
        #expect(!vm.isSuccess)
    }

    // MARK: - Successful reset

    @Test("Valid inputs with successful repository call sets isSuccess")
    func validInputs_success_setsIsSuccess() async {
        let repo = MockAuthRepository()
        repo.resetPasswordResult = .success(())
        let vm = makeViewModel(authRepository: repo)
        vm.pin = "123456"
        vm.newPassword = "securePass"
        vm.confirmPassword = "securePass"

        await vm.resetPassword()

        #expect(vm.isSuccess)
        #expect(vm.error == nil)
    }

    @Test("Correct pin is passed to repository as Int")
    func correctPin_passedToRepository() async {
        let repo = MockAuthRepository()
        repo.resetPasswordResult = .success(())
        let vm = makeViewModel(authRepository: repo)
        vm.pin = "654321"
        vm.newPassword = "securePass"
        vm.confirmPassword = "securePass"

        await vm.resetPassword()

        #expect(repo.resetPasswordCallCount == 1)
        #expect(repo.lastResetPasswordPin == 654321)
    }

    // MARK: - Repository failure

    @Test("Repository failure sets error and does not set isSuccess")
    func repositoryFailure_setsError() async {
        let repo = MockAuthRepository()
        repo.resetPasswordResult = .failure(MockError.generic)
        let vm = makeViewModel(authRepository: repo)
        vm.pin = "123456"
        vm.newPassword = "securePass"
        vm.confirmPassword = "securePass"

        await vm.resetPassword()

        #expect(!vm.isSuccess)
        #expect(vm.error != nil)
    }

    // MARK: - Loading state

    @Test("isLoading is false after reset completes")
    func isLoading_falseAfterCompletion() async {
        let repo = MockAuthRepository()
        repo.resetPasswordResult = .failure(MockError.generic)
        let vm = makeViewModel(authRepository: repo)
        vm.pin = "123456"
        vm.newPassword = "securePass"
        vm.confirmPassword = "securePass"

        await vm.resetPassword()

        #expect(!vm.isLoading)
    }

    @Test("Error is cleared at the start of a new reset attempt")
    func previousError_clearedOnNewAttempt() async {
        let repo = MockAuthRepository()
        repo.resetPasswordResult = .failure(MockError.generic)
        let vm = makeViewModel(authRepository: repo)
        vm.pin = "123456"
        vm.newPassword = "securePass"
        vm.confirmPassword = "securePass"
        await vm.resetPassword()
        #expect(vm.error != nil)

        // Second attempt succeeds
        repo.resetPasswordResult = .success(())
        await vm.resetPassword()

        #expect(vm.error == nil)
        #expect(vm.isSuccess)
    }
}
