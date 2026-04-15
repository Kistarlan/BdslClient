//
//  ChangePasswordSubmitButton.swift
//  BdslClient
//

import DesignSystem
import SwiftUI

struct ChangePasswordSubmitButton: View {
    @Environment(\.theme) private var theme

    let isLoading: Bool
    let onSubmit: () -> Void

    var body: some View {
        Button(action: onSubmit) {
            Text(.changePassword)
                .font(theme.typography.button)
                .foregroundStyle(
                    isLoading
                        ? theme.colors.buttonPrimaryDisabledForeground
                        : theme.colors.buttonPrimaryForeground
                )
                .frame(maxWidth: .infinity)
                .padding(theme.layout.spacing.m)
                .background(
                    isLoading
                        ? theme.colors.buttonPrimaryDisabledBackground
                        : theme.colors.buttonPrimaryBackground
                )
                .clipShape(.rect(cornerRadius: theme.layout.cornerRadius.l))
        }
    }
}
