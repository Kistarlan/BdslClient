//
//  FilterBlock.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 03.03.2026.
//


import SwiftUI
import DesignSystem

struct FilterBlock<Item>: View {
    @Environment(\.theme) private var theme

    let title: LocalizedStringResource
    let items: [Item]
    @Binding var selection: Set<String>
    let id: KeyPath<Item, String>
    let titleKey: KeyPath<Item, String>
    let isExpanded: Bool
    let onHeaderTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: theme.layout.spacing.s) {

            FilterSectionHeader(title: title,
                                isExpanded: isExpanded,
                                onHeaderTap: onHeaderTap)

            if isExpanded {
                filterItems
            }
        }
    }

    var filterItems: some View {
        WrapLayout {
            ForEach(items, id: id) { item in

                let itemId = item[keyPath: id]
                let isSelected = selection.contains(itemId)

                FilterChip(
                    title: item[keyPath: titleKey],
                    isSelected: isSelected
                ) {
                    toggle(itemId)
                }
            }
        }
    }

    private func toggle(_ id: String) {
        if selection.contains(id) {
            selection.remove(id)
        } else {
            selection.insert(id)
        }
    }
}
