//
//  OptionRow.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 26.03.2026.
//

import DesignSystem
import SwiftUI

struct OptionRow: View {
    @Environment(\.theme) private var theme

    let title: String
    let isSelected: Bool
    let value: String?
    let action: () -> Void

    init(title: String, isSelected: Bool, value: String?, action: @escaping () -> Void) {
        self.title = title
        self.isSelected = isSelected
        self.value = value
        self.action = action
    }

    init(title: String, isSelected: Bool, action: @escaping () -> Void) {
        self.title = title
        self.isSelected = isSelected
        value = nil
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .foregroundStyle(theme.colors.textPrimary)

                Spacer()

                if let value {
                    Text(value)
                        .foregroundStyle(theme.colors.textSecondary)
                }
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundStyle(theme.colors.accent)
                }
            }
            .padding(.vertical, theme.layout.spacing.m)
        }
    }
}
