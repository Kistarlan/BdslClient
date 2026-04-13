//
//  FilterSectionHeader.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 06.03.2026.
//

import DesignSystem
import SwiftUI

struct FilterSectionHeader: View {
    @Environment(\.theme) private var theme

    let title: LocalizedStringResource
    let isExpanded: Bool
    let onHeaderTap: () -> Void

    var body: some View {
        Button {
            withAnimation {
                onHeaderTap()
            }
        } label: {
            HStack {
                Text(title)
                    .font(theme.typography.secondary.weight(.semibold))
                    .foregroundStyle(theme.colors.textPrimary)

                Spacer()

                Image(systemName: "chevron.down")
                    .rotationEffect(.degrees(isExpanded ? 0 : -90))
                    .foregroundStyle(theme.colors.iconSecondary)
                    .font(theme.typography.secondary)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
