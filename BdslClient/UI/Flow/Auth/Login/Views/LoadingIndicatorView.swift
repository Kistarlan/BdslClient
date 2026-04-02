//
//  LoadingIndicatorView.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 02.04.2026.
//

import SwiftUI
import DesignSystem

struct LoadingIndicatorView: View {
    @Environment(\.theme) private var theme

    var body: some View {
        VStack(spacing: theme.layout.spacing.s) {
            ProgressView()
                .tint(theme.colors.accent)

            Text(.confirmYourEntranceInTelegramBot)
                .foregroundStyle(theme.colors.textSecondary)
                .font(theme.typography.secondary)
        }
        .padding()
    }
}
