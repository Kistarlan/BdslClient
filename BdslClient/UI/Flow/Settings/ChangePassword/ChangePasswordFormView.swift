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

    var body: some View {
        ScrollView {
            VStack(spacing: theme.layout.spacing.l) {
                ChangePasswordFieldsSection(
                    currentPassword: $viewModel.currentPassword,
                    newPassword: $viewModel.newPassword,
                    confirmPassword: $viewModel.confirmPassword
                )

                if let error = viewModel.error {
                    ErrorSection(error: error)
                }

                if viewModel.isLoading {
                    LoadingIndicatorView()
                }

                ChangePasswordSubmitButton(isLoading: viewModel.isLoading, onSubmit: onSubmit)
            }
            .disabled(viewModel.isLoading)
            .padding(theme.layout.spacing.l)
        }
    }
}
