//
//  PhoneFieldView.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 02.04.2026.
//

import SwiftUI
import DesignSystem

struct PhoneFieldView: View {
    @Binding var phone: String
    @Environment(\.theme) private var theme

    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "person")
                .foregroundStyle(theme.colors.iconSecondary)
                .padding(.vertical, theme.layout.spacing.s)
                .padding(.horizontal, theme.layout.spacing.xs)

            Text("+38")
                .foregroundStyle(theme.colors.textPrimary)
                .padding(.horizontal, theme.layout.spacing.xs)

            TextField(.phone, text: $phone)
                .keyboardType(.numberPad)
                .numbersOnly(text: $phone, maxLength: 10)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .foregroundStyle(theme.colors.textPrimary)
        }
        .padding(theme.layout.spacing.m)
        .background(.ultraThinMaterial)
        .clipShape(.rect(cornerRadius: theme.layout.cornerRadius.l))
    }
}
