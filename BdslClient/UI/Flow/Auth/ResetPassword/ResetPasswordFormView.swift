//
//  ResetPasswordFormView.swift
//  BdslClient
//

import DesignSystem
import SwiftUI

struct ResetPasswordFormView: View {
    @Environment(\.theme) private var theme
    @Bindable var viewModel: ResetPasswordViewModel
    let onChangePassword: () -> Void

    var body: some View {
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
                pinField

                Text(.enterPinDescription)
                    .font(theme.typography.caption)
                    .foregroundStyle(theme.colors.textSecondary)
                    .multilineTextAlignment(.center)

                newPasswordField

                confirmPasswordField

                if let error = viewModel.error {
                    ErrorSection(error: error)
                }

                if viewModel.isLoading {
                    LoadingIndicatorView()
                }

                changePasswordButton
            }
            .disabled(viewModel.isLoading)
            .padding(theme.layout.spacing.l)

            Spacer()
        }
    }

    private var pinField: some View {
        HStack(spacing: 0) {
            Image(systemName: "lock.shield")
                .foregroundStyle(theme.colors.iconSecondary)
                .padding(.vertical, theme.layout.spacing.s)
                .padding(.horizontal, theme.layout.spacing.xs)
                .accessibilityHidden(true)

            TextField(.pinCode, text: $viewModel.pin)
                .keyboardType(.numberPad)
                .numbersOnly(text: $viewModel.pin, maxLength: 6)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .foregroundStyle(theme.colors.textPrimary)
        }
        .padding(theme.layout.spacing.m)
        .background(.ultraThinMaterial)
        .clipShape(.rect(cornerRadius: theme.layout.cornerRadius.l))
    }

    private var newPasswordField: some View {
        HStack {
            Image(systemName: "lock")
                .foregroundStyle(theme.colors.iconSecondary)
                .accessibilityHidden(true)

            SecureField(.newPassword, text: $viewModel.newPassword)
                .foregroundStyle(theme.colors.textPrimary)
        }
        .padding(theme.layout.spacing.m)
        .background(.ultraThinMaterial)
        .clipShape(.rect(cornerRadius: theme.layout.cornerRadius.m))
    }

    private var confirmPasswordField: some View {
        HStack {
            Image(systemName: "lock.fill")
                .foregroundStyle(theme.colors.iconSecondary)
                .accessibilityHidden(true)

            SecureField(.confirmPassword, text: $viewModel.confirmPassword)
                .foregroundStyle(theme.colors.textPrimary)
        }
        .padding(theme.layout.spacing.m)
        .background(.ultraThinMaterial)
        .clipShape(.rect(cornerRadius: theme.layout.cornerRadius.m))
    }

    private var changePasswordButton: some View {
        Button(action: onChangePassword) {
            Text(.changePassword)
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
}
