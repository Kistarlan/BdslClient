//
//  CustomTextField.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 12.02.2026.
//

import DesignSystem
import Models
import SwiftUI

struct CustomTextField: View {
    // MARK: - Environment

    @Environment(\.theme) private var theme

    // MARK: - Input

    let title: LocalizedStringResource
    @Binding var text: String

    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType? = nil
    var isSecure: Bool = false
    var error: LocalizedStringResource? = nil
    var isDisabled: Bool = false
    var prefix: String?

    // MARK: - State

    @FocusState private var isFocused: Bool

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: theme.layout.spacing.xs) {
            Text(title)
                .font(theme.typography.label)
                .foregroundStyle(labelColor)

            inputField
                .padding(.horizontal, theme.layout.spacing.m)
                .frame(height: 48)
                .background(backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: theme.layout.cornerRadius.m)
                        .stroke(borderColor, lineWidth: 1)
                )
                .clipShape(
                    RoundedRectangle(cornerRadius: theme.layout.cornerRadius.m)
                )

            if let error {
                Text(error)
                    .font(theme.typography.error)
                    .foregroundStyle(theme.colors.textError)
            }
        }
    }
}

private extension CustomTextField {
    @ViewBuilder
    var inputField: some View {
        HStack(spacing: 0) {
            if isSecure {
                SecureField("", text: $text)
                    .focused($isFocused)
                    .keyboardType(keyboardType)
                    .textContentType(textContentType)
                    .disabled(isDisabled)
            } else {
                if let prefix {
                    Text(prefix)
                }

                TextField(text: $text) {}
                    .focused($isFocused)
                    .keyboardType(keyboardType)
                    .textContentType(textContentType)
                    .font(theme.typography.input)
                    .disabled(isDisabled)
            }
        }
    }
}

private extension CustomTextField {
    var borderColor: Color {
        if error != nil {
            return theme.colors.textFieldBorderError
        }
        if isFocused {
            return theme.colors.textFieldBorderFocused
        }
        return theme.colors.textFieldBorder
    }

    var backgroundColor: Color {
        isDisabled
            ? theme.colors.textFieldBackgroundDisabled
            : theme.colors.textFieldBackground
    }

    var labelColor: Color {
        error != nil
            ? theme.colors.textError
            : theme.colors.textSecondary
    }
}

#Preview {
    NavigationStack {
        EditUserInfoView(viewModel: AppContainer.shared.viewModelsFactory
            .makeEditUserInfoViewModel(user: UserDTO.previewValue().toDomain()))
    }
    .setupPreviewEnvironments(.light)
}
