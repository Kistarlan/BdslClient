//
//  SubscriptionSelectionSection.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 21.04.2026.
//

import DesignSystem
import SwiftUI

/// A card-style section container with a title and a chip wrap layout.
/// Reuses the filter-chip visual language for subscription selection flows.
struct SubscriptionSelectionSection<Content: View>: View {
    @Environment(\.theme) private var theme

    let title: LocalizedStringResource
    @ViewBuilder let content: Content

    init(title: LocalizedStringResource, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: theme.layout.spacing.sm) {
            Text(title)
                .font(theme.typography.sectionTitle)
                .foregroundStyle(theme.colors.textPrimary)

            WrapLayout {
                content
            }
        }
        .padding(theme.layout.spacing.m)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(theme.colors.cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: theme.layout.cornerRadius.l)
                .stroke(theme.colors.materialBorder)
        )
        .clipShape(RoundedRectangle(cornerRadius: theme.layout.cornerRadius.l))
    }
}
