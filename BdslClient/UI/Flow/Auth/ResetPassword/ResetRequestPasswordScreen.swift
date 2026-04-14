//
//  ResetRequestPasswordScreen.swift
//  BdslClient
//

import DesignSystem
import Models
import Navigation
import Services
import SwiftUI

struct ResetRequestPasswordScreen: View {
    @Environment(\.theme) private var theme
    @Environment(Router.self) private var router
    @State private var viewModel: ResetRequestPasswordViewModel

    init(viewModel: ResetRequestPasswordViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            LoginBackgroundView()
                .ignoresSafeArea()

            VStack(spacing: theme.layout.spacing.l) {
                Spacer()

                Image(.appLogo)
                    .resizable()
                    .scaledToFit()
                    .containerRelativeFrame(.vertical) { length, _ in
                        length / 4.0
                    }
                    .accessibilityHidden(true)

                VStack(spacing: theme.layout.spacing.m) {
                    PhoneFieldView(phone: $viewModel.phone)

                    if let phoneError = viewModel.phoneError {
                        ErrorSection(error: phoneError)
                    }

                    if let error = viewModel.error {
                        ErrorSection(error: error)
                    }

                    if viewModel.isLoading {
                        LoadingIndicatorView()
                    }

                    sendPinButton
                }
                .disabled(viewModel.isLoading)
                .padding(theme.layout.spacing.l)

                Spacer()
            }
        }
        .navigationTitle(Text(LocalizedStringResource.resetPasswordTitle))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var sendPinButton: some View {
        Button(action: sendPin) {
            Text(.resetPassword)
                .font(theme.typography.button)
                .foregroundStyle(theme.colors.textPrimary)
                .frame(maxWidth: .infinity)
                .padding(theme.layout.spacing.m)
                .background(
                    viewModel.isLoading
                        ? theme.colors.buttonDisabled
                        : theme.colors.backgroundSecondary
                )
                .clipShape(.rect(cornerRadius: theme.layout.cornerRadius.m))
        }
    }

    private func sendPin() {
        Task {
            if let inviteKey = await viewModel.requestReset() {
                router.push(.resetPassword(inviteKey: inviteKey))
            }
        }
    }
}

#Preview {
    let router = Router.previewRouter()
    NavigationContainer(parentRouter: router) {
        ResetRequestPasswordScreen(
            viewModel: ResetRequestPasswordViewModel(
                authRepository: AppContainer.shared.services.authRepository
            )
        )
    }
    .setupPreviewEnvironments(.light, router)
}
