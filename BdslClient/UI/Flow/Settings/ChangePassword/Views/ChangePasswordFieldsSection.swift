//
//  ChangePasswordFieldsSection.swift
//  BdslClient
//

import DesignSystem
import SwiftUI

struct ChangePasswordFieldsSection: View {
    @Environment(\.theme) private var theme

    @Binding var currentPassword: String
    @Binding var newPassword: String
    @Binding var confirmPassword: String

    var body: some View {
        VStack(spacing: theme.layout.spacing.m) {
            PasswordInputField(
                icon: "lock.shield",
                placeholder: .currentPassword,
                text: $currentPassword
            )

            VStack(spacing: theme.layout.spacing.s) {
                PasswordInputField(
                    icon: "lock",
                    placeholder: .newPassword,
                    text: $newPassword
                )

                PasswordInputField(
                    icon: "lock.fill",
                    placeholder: .confirmPassword,
                    text: $confirmPassword
                )
            }
        }
    }
}
