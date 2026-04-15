//
//  ChangePasswordFormView.swift
//  BdslClient
//

import DesignSystem
import SwiftUI

struct ChangePasswordFormView: View {
    @Environment(\.theme) private var theme
    @Bindable var viewModel: ChangePasswordViewModel
    let onSubmit: () -> Void

    @State private var isCurrentRevealed = false
    @State private var isNewRevealed = false
    @State private var isConfirmRevealed = false

    var body: some View {
        ScrollView {
            VStack(spacing: theme.layout.spacing.l) {
                fieldsSection

                if let error = viewModel.error {
                    ErrorSection(error: error)
                }

                if viewModel.isLoading {
                    LoadingIndicatorView()
                }

                submitButton
            }
            .disabled(viewModel.isLoading)
            .padding(theme.layout.spacing.l)
        }
    }

    private var fieldsSection: some View {
        VStack(spacing: theme.layout.spacing.m) {
            passwordField(
                icon: "lock.shield",
                placeholder: LocalizedStringResource.currentPassword,
                text: $viewModel.currentPassword,
                isRevealed: $isCurrentRevealed
            )

            VStack(spacing: theme.layout.spacing.s) {
                passwordField(
                    icon: "lock",
                    placeholder: LocalizedStringResource.newPassword,
                    text: $viewModel.newPassword,
                    isRevealed: $isNewRevealed
                )

                passwordField(
                    icon: "lock.fill",
                    placeholder: LocalizedStringResource.confirmPassword,
                    text: $viewModel.confirmPassword,
                    isRevealed: $isConfirmRevealed
                )
            }
        }
    }

    private func passwordField(
        icon: String,
        placeholder: LocalizedStringResource,
        text: Binding<String>,
        isRevealed: Binding<Bool>
    ) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(theme.colors.iconSecondary)
                .accessibilityHidden(true)

            Group {
                if isRevealed.wrappedValue {
                    TextField(placeholder, text: text)
                } else {
                    SecureField(placeholder, text: text)
                }
            }
            .foregroundStyle(theme.colors.textPrimary)
            .textContentType(.password)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)

            Button {
                isRevealed.wrappedValue.toggle()
            } label: {
                Image(systemName: isRevealed.wrappedValue ? "eye.slash" : "eye")
                    .foregroundStyle(theme.colors.iconSecondary)
            }
            .accessibilityLabel(isRevealed.wrappedValue ? "Hide password" : "Show password")
        }
        .padding(theme.layout.spacing.m)
        .background(.ultraThinMaterial)
        .clipShape(.rect(cornerRadius: theme.layout.cornerRadius.m))
    }

    private var submitButton: some View {
        Button(action: onSubmit) {
            Text(.changePassword)
                .font(theme.typography.button)
                .foregroundStyle(
                    viewModel.isLoading
                        ? theme.colors.buttonPrimaryDisabledForeground
                        : theme.colors.buttonPrimaryForeground
                )
                .frame(maxWidth: .infinity)
                .padding(theme.layout.spacing.m)
                .background(
                    viewModel.isLoading
                        ? theme.colors.buttonPrimaryDisabledBackground
                        : theme.colors.buttonPrimaryBackground
                )
                .clipShape(.rect(cornerRadius: theme.layout.cornerRadius.l))
        }
    }
}
