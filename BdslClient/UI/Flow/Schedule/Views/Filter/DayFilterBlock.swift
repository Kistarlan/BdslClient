//
//  DayFilterBlock.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 03.03.2026.
//

import DesignSystem
import Models
import SwiftUI

struct DayFilterBlock: View {
    @Environment(\.theme) private var theme

    let title: LocalizedStringResource
    let items: [DayRecurrenceType]
    @Binding var selection: Set<DayRecurrenceType>
    let isExpanded: Bool
    let onHeaderTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: theme.layout.spacing.s) {
            FilterSectionHeader(
                title: title,
                isExpanded: isExpanded,
                onHeaderTap: onHeaderTap
            )

            if isExpanded {
                filterItems
            }
        }
    }

    var filterItems: some View {
        WrapLayout {
            ForEach(items) { day in
                FilterChip(
                    localizedTitle: day.localized,
                    isSelected: selection.contains(day)
                ) {
                    toggle(day)
                }
            }
        }
    }

    private func toggle(_ day: DayRecurrenceType) {
        if selection.contains(day) {
            selection.remove(day)
        } else {
            selection.insert(day)
        }
    }
}
