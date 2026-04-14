//
//  ResetPasswordScreen.swift
//  BdslClient
//

import DesignSystem
import Navigation
import SwiftUI

struct ResetPasswordScreen: View {
    @Environment(\.theme) private var theme
    @Environment(Router.self) private var router
    @State private var viewModel: ResetPasswordViewModel

    init(viewModel: ResetPasswordViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            LoginBackgroundView()
                .ignoresSafeArea()

            if viewModel.isSuccess {
                ResetPasswordSuccessView(onBackToSignIn: backToSignIn)
            } else {
                ResetPasswordFormView(viewModel: viewModel, onChangePassword: changePassword)
            }
        }
        .navigationTitle(Text(LocalizedStringResource.resetPasswordTitle))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(viewModel.isSuccess)
    }

    private func backToSignIn() {
        router.pop(destination: .login)
    }

    private func changePassword() {
        Task { await viewModel.resetPassword() }
    }
}
