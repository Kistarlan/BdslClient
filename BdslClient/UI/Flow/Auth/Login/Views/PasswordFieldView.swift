//
//  PasswordFieldView.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 02.04.2026.
//

import SwiftUI
import DesignSystem

struct PasswordFieldView: View {
    @Environment(\.theme) private var theme
    @Binding var password: String

    var body: some View {
        HStack {
            Image(systemName: "lock")
                .foregroundStyle(theme.colors.iconSecondary)

            SecureField(.password, text: $password)
                .foregroundStyle(theme.colors.textPrimary)
        }
        .padding(theme.layout.spacing.m)
        .background(.ultraThinMaterial)
        .clipShape(.rect(cornerRadius: theme.layout.cornerRadius.m))
    }
}
