//
//  LoginScreen.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 23.01.2026.
//

import DesignSystem
import Models
import Navigation
import SwiftUI

struct LoginScreen: View {
    @Environment(AppState.self) private var appState
    @Environment(Router.self) private var router
    @Environment(\.theme) private var theme
    @State private var viewModel: LoginViewModel
    @State private var isSecure: Bool = true

    init(_ loginViewModel: LoginViewModel) {
        _viewModel = State(wrappedValue: loginViewModel)
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                LoginBackgroundView()
                    .ignoresSafeArea()
                VStack(spacing: theme.layout.spacing.l) {
                    Spacer()

                    Image(.appLogo)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.height / 4.0, height: geo.size.height / 4.0)

                    loginSection

                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onDisappear {
            viewModel.reset()
        }
        .onChange(of: appState.state) {
            if appState.state.isAuthenticated {
                router.navigateToRoot()
            }
        }
    }
}

extension LoginScreen {
    private var loginSection: some View {
        VStack(spacing: theme.layout.spacing.m) {
            phoneSection

            if let error = viewModel.phoneError {
                errorSection(error: error)
            }

            if viewModel.loginByPassword {
                passwordSection
            }

            if let error = viewModel.loginError {
                errorSection(error: error)
            }

            if viewModel.isLoading {
                loadingIndicator
            }

            loginButton

            inputTypeSelection
        }
        .disabled(viewModel.isLoading)
        .padding(theme.layout.spacing.l)
    }

    private var loadingIndicator: some View {
        VStack(spacing: theme.layout.spacing.s) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: theme.colors.accent))
            Text(.confirmYourEntranceInTelegramBot)
                .foregroundColor(theme.colors.textSecondary)
                .font(theme.typography.secondary)
        }
        .padding()
    }

    private var phoneSection: some View {
        HStack(spacing: 0) {
            Image(systemName: "person")
                .foregroundColor(theme.colors.iconSecondary)
                .padding([.top, .bottom], theme.layout.spacing.s)
                .padding([.leading, .trailing], theme.layout.spacing.xs)

            Text("+38")
                .foregroundColor(theme.colors.textPrimary)
                .padding([.leading, .trailing], theme.layout.spacing.xs)

            TextField(.phone, text: $viewModel.phone)
                .keyboardType(.numberPad)
                .numbersOnly(text: $viewModel.phone, maxLength: 10)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .foregroundColor(theme.colors.textPrimary)
        }
        .padding(theme.layout.spacing.m)
        .background(.ultraThinMaterial)
        .cornerRadius(theme.layout.cornerRadius.l)
    }

    private var passwordSection: some View {
        HStack {
            Image(systemName: "lock")
                .foregroundColor(theme.colors.iconSecondary)
            SecureField(.password, text: $viewModel.password)
                .foregroundColor(theme.colors.textPrimary)
        }
        .padding(theme.layout.spacing.m)
        .background(.ultraThinMaterial)
        .cornerRadius(theme.layout.cornerRadius.m)
    }

    private var inputTypeSelection: some View {
        HStack(spacing: theme.layout.spacing.s) {
            Text(viewModel.loginByPassword ? .loginVia : .loginBy)
                .foregroundColor(theme.colors.textSecondary)

            Button(action: {
                withAnimation {
                    viewModel.loginByPassword.toggle()
                }
            }) {
                Text(viewModel.loginByPassword ? .telegram : .password)
                    .fontWeight(.bold)
                    .foregroundColor(theme.colors.accent)
            }
        }
    }

    private var loginButton: some View {
        Button(action: viewModel.login) {
            Text(.login)
                .font(theme.typography.button)
                .foregroundColor(theme.colors.textPrimary)
                .frame(maxWidth: .infinity)
                .padding(theme.layout.spacing.m)
                .background(viewModel.isLoading ? theme.colors.buttonDisabled : theme.colors.backgroundSecondary)
                .cornerRadius(theme.layout.cornerRadius.m)
        }
    }

    private func errorSection(error: LocalizedStringResource) -> some View {
        Text(error)
            .foregroundColor(.red)
            .font(theme.typography.secondary)
    }
}

#Preview {
    NavigationStack {
        LoginScreen(AppContainer.shared.viewModelsFactory.makeLoginViewModel())
            .setupPreviewEnvironments(.light)
    }
}
