//
//  LoginButton.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 02.04.2026.
//

import SwiftUI
import DesignSystem

struct LoginButtonView: View {
    let isLoading: Bool
    let action: () -> Void

    @Environment(\.theme) private var theme

    var body: some View {
        Button(action: action) {
            Text(.login)
                .font(theme.typography.button)
                .foregroundStyle(theme.colors.textPrimary)
                .frame(maxWidth: .infinity)
                .padding(theme.layout.spacing.m)
                .background(
                    isLoading
                    ? theme.colors.buttonDisabled
                    : theme.colors.backgroundSecondary
                )
                .clipShape(.rect(cornerRadius: theme.layout.cornerRadius.m))
        }
        .disabled(isLoading)
    }
}
