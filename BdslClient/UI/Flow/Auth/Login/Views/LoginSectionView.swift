//
//  LoginSectionView.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 02.04.2026.
//


import DesignSystem
import SwiftUI

struct LoginSectionView: View {
    @Environment(\.theme) private var theme
    @State private var viewModel: LoginViewModel

    init(_ loginViewModel: LoginViewModel) {
        _viewModel = State(wrappedValue: loginViewModel)
    }

    var body: some View {
        VStack(spacing: theme.layout.spacing.m) {
            PhoneFieldView(phone: $viewModel.phone)

            if let error = viewModel.phoneError {
                ErrorSection(error: error)
            }

            if viewModel.loginByPassword {
                PasswordFieldView(password: $viewModel.password)
            }

            if let error = viewModel.loginError {
                ErrorSection(error: error)
            }

            if viewModel.isLoading {
                LoadingIndicatorView()
            }

            LoginButtonView(isLoading: viewModel.isLoading, action: viewModel.login)

            InputTypeSelectionView(isLoginByPassword: viewModel.loginByPassword, onToggle: viewModel.toggleLoginByPassword)
        }
        .disabled(viewModel.isLoading)
        .padding(theme.layout.spacing.l)
    }
}
