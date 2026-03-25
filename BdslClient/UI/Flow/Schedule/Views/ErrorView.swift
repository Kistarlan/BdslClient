//
//  ErrorView.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 24.03.2026.
//

import SwiftUI
import DesignSystem

struct ErrorView: View {
    @Environment(\.theme) private var theme

    let errorMessage: LocalizedStringResource
    let retryAction: () -> Void

    var body: some View {
        VStack(spacing: theme.layout.spacing.l) {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
                .foregroundColor(theme.colors.textError)

            Text(errorMessage)
                .font(theme.typography.error)
                .multilineTextAlignment(.center)
                .foregroundColor(theme.colors.textPrimary)
                .padding(.horizontal, theme.layout.spacing.m)

            Button(action: retryAction) {
                Text(.retry)
                    .font(theme.typography.button)
                    .foregroundColor(theme.colors.buttonPrimaryForeground)
                    .padding(.vertical, theme.layout.spacing.sm)
                    .padding(.horizontal, theme.layout.spacing.l)
                    .background(theme.colors.buttonPrimaryBackground)
                    .cornerRadius(theme.layout.cornerRadius.m)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.colors.appBackground)
        .padding(theme.layout.spacing.l)
    }
}
