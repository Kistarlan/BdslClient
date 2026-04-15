//
//  ChangePasswordSuccessView.swift
//  BdslClient
//

import DesignSystem
import SwiftUI

struct ChangePasswordSuccessView: View {
    @Environment(\.theme) private var theme

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
        }
        .padding(theme.layout.spacing.l)
    }
}
