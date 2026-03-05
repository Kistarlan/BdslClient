//
//  FilterChip.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 03.03.2026.
//

import SwiftUI
import DesignSystem
import Models

struct FilterChip: View {
    @Environment(\.locale) private var locale
    @Environment(\.theme) private var theme

    let title: String?
    let localizedTitle: LocalizedStringResource?
    let isSelected: Bool
    let action: () -> Void

    init(title: String?, isSelected: Bool, action: @escaping () -> Void) {
        self.title = title
        self.localizedTitle = nil
        self.isSelected = isSelected
        self.action = action
    }

    init(localizedTitle: LocalizedStringResource?, isSelected: Bool, action: @escaping () -> Void) {
        self.title = nil
        self.localizedTitle = localizedTitle
        self.isSelected = isSelected
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(displayTitle)
                .font(theme.typography.caption)
                .foregroundStyle(textColor)
                .padding(.horizontal, theme.layout.spacing.sm)
                .padding(.vertical, theme.layout.spacing.s)
                .background(background)
                .overlay(border)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

private extension FilterChip {

    var background: Color {
        isSelected
        ? theme.colors.chipSelectedBackground
        : theme.colors.chipBackground
    }

    var textColor: Color {
        isSelected
        ? theme.colors.chipSelectedText
        : theme.colors.chipText
    }

    var border: some View {
        Capsule()
            .stroke(
                isSelected
                ? theme.colors.chipSelectedBorder
                : theme.colors.chipBorder
            )
    }

    var displayTitle: String {
        if let localizedTitle {
            localizedTitle.localized(locale: locale)
        } else {
            title ?? ""
        }
    }
}

#Preview {
    var isSelcetd: Bool = false

    VStack {
        FilterChip(
            title: "title title", isSelected: isSelcetd, action: { isSelcetd.toggle()
            }
        )
    }
    .frame(width: 500, height: 500)
    .background(LightTheme().colors.cardBackground)
    .setupPreviewEnvironments(ThemeMode.light)
}

