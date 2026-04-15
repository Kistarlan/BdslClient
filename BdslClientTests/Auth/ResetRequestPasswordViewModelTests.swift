//
//  ResetRequestPasswordViewModelTests.swift
//  BdslClientTests
//

import Testing
import Models
@testable import BdslClient

@MainActor
struct ResetRequestPasswordViewModelTests {
    private func makeViewModel(
        authRepository: MockAuthRepository = MockAuthRepository()
    ) -> ResetRequestPasswordViewModel {
        ResetRequestPasswordViewModel(authRepository: authRepository)
    }

    // MARK: - Phone validation

    @Test("Invalid phone sets phoneError and returns nil")
    func invalidPhone_setsPhoneError() async {
        let vm = makeViewModel()
        vm.phone = "123"

        let result = await vm.requestReset()

        #expect(result == nil)
        #expect(vm.phoneError != nil)
    }

    @Test("Empty phone sets phoneError and returns nil")
    func emptyPhone_setsPhoneError() async {
        let vm = makeViewModel()
        vm.phone = ""

        let result = await vm.requestReset()

        #expect(result == nil)
        #expect(vm.phoneError != nil)
    }

    @Test("Valid phone clears phoneError before calling repository")
    func validPhone_clearsPhoneError() async {
        let repo = MockAuthRepository()
        repo.resetPasswordRequestResult = .failure(MockError.generic)
        let vm = makeViewModel(authRepository: repo)
        vm.phone = "0501234567"

        _ = await vm.requestReset()

        #expect(vm.phoneError == nil)
    }

    // MARK: - Repository interaction

    @Test("Valid phone calls repository with correct phone")
    func validPhone_callsRepositoryWithPhone() async {
        let repo = MockAuthRepository()
        repo.resetPasswordRequestResult = .success(
            ResetPasswordInviteKey(inviteKey: "key-abc")
        )
        let vm = makeViewModel(authRepository: repo)
        vm.phone = "0501234567"

        _ = await vm.requestReset()

        #expect(repo.resetPasswordRequestCallCount == 1)
        #expect(repo.lastResetRequestPhone == "0501234567")
    }

    @Test("Successful request returns invite key")
    func success_returnsInviteKey() async {
        let repo = MockAuthRepository()
        let expectedKey = ResetPasswordInviteKey(inviteKey: "invite-xyz")
        repo.resetPasswordRequestResult = .success(expectedKey)
        let vm = makeViewModel(authRepository: repo)
        vm.phone = "0501234567"

        let result = await vm.requestReset()

        #expect(result?.inviteKey == expectedKey.inviteKey)
    }

    @Test("Repository failure sets error and returns nil")
    func repositoryFailure_setsError() async {
        let repo = MockAuthRepository()
        repo.resetPasswordRequestResult = .failure(MockError.generic)
        let vm = makeViewModel(authRepository: repo)
        vm.phone = "0501234567"

        let result = await vm.requestReset()

        #expect(result == nil)
        #expect(vm.error != nil)
    }

    // MARK: - Loading state

    @Test("isLoading is false after request completes")
    func isLoading_falseAfterCompletion() async {
        let repo = MockAuthRepository()
        repo.resetPasswordRequestResult = .failure(MockError.generic)
        let vm = makeViewModel(authRepository: repo)
        vm.phone = "0501234567"

        _ = await vm.requestReset()

        #expect(!vm.isLoading)
    }
}
