//
//  ResetPasswordSuccessView.swift
//  BdslClient
//

import DesignSystem
import SwiftUI

struct ResetPasswordSuccessView: View {
    @Environment(\.theme) private var theme
    let onBackToSignIn: () -> Void

    var body: some View {
        VStack(spacing: theme.layout.spacing.ml) {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 72, height: 72)
                .foregroundStyle(theme.colors.accent)
                .accessibilityHidden(true)

            Text(.passwordChangedSuccessfully)
                .font(theme.typography.screenTitle)
                .foregroundStyle(theme.colors.textPrimary)
                .multilineTextAlignment(.center)

            Text(.passwordChangedDescription)
                .font(theme.typography.secondary)
                .foregroundStyle(theme.colors.textSecondary)
                .multilineTextAlignment(.center)

            Button(action: onBackToSignIn) {
                Text(.backToSignIn)
                    .font(theme.typography.button)
                    .foregroundStyle(theme.colors.textPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(theme.layout.spacing.m)
                    .background(theme.colors.backgroundSecondary)
                    .clipShape(.rect(cornerRadius: theme.layout.cornerRadius.m))
            }
            .padding(.horizontal, theme.layout.spacing.l)
            .padding(.top, theme.layout.spacing.s)
        }
        .padding(theme.layout.spacing.l)
    }
}
