//
//  PasswordInputField.swift
//  BdslClient
//

import DesignSystem
import SwiftUI

struct PasswordInputField: View {
    @Environment(\.theme) private var theme

    let icon: String
    let placeholder: LocalizedStringResource
    @Binding var text: String

    @State private var isRevealed = false

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(theme.colors.iconSecondary)
                .accessibilityHidden(true)

            Group {
                if isRevealed {
                    TextField(placeholder, text: $text)
                } else {
                    SecureField(placeholder, text: $text)
                }
            }
            .foregroundStyle(theme.colors.textPrimary)
            .textContentType(.password)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)

            Button {
                isRevealed.toggle()
            } label: {
                Image(systemName: isRevealed ? "eye.slash" : "eye")
                    .foregroundStyle(theme.colors.iconSecondary)
            }
            .accessibilityLabel(isRevealed ? "Hide password" : "Show password")
        }
        .padding(theme.layout.spacing.m)
        .background(theme.colors.textFieldBackground)
        .overlay(
            RoundedRectangle(cornerRadius: theme.layout.cornerRadius.m)
                .stroke(theme.colors.textFieldBorder, lineWidth: 1)
        )
        .clipShape(.rect(cornerRadius: theme.layout.cornerRadius.m))
    }
}
