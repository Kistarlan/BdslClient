//
//  InputTypeSelectionView.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 02.04.2026.
//

import SwiftUI
import DesignSystem

struct InputTypeSelectionView: View {
    let isLoginByPassword: Bool
    let onToggle: () -> Void

    @Environment(\.theme) private var theme

    var body: some View {
        HStack(spacing: theme.layout.spacing.s) {
            Text(isLoginByPassword ? .loginVia : .loginBy)
                .foregroundStyle(theme.colors.textSecondary)

            Button(action: onToggle) {
                Text(isLoginByPassword ? .telegram : .password)
                    .bold()
                    .foregroundStyle(theme.colors.accent)
            }
        }
    }
}
