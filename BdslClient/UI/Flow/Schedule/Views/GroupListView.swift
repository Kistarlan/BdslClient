//
//  GroupListView.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 03.03.2026.
//

import SwiftUI
import Models
import DesignSystem
import Navigation

struct GroupListView: View {
    @Environment(\.locale) private var locale
    @Environment(\.theme) private var theme

    let isLoading: Bool
    let groupSections: [ScheduleGroupSection]

    var body: some View {
        LazyVStack(alignment: .leading, spacing: theme.layout.spacing.m) {
            ForEach(groupSections) { section in
                VStack(alignment: .leading, spacing: theme.layout.spacing.sm) {

                    sectionHeader(days: section.days)

                    ForEach(section.groups) { group in
                        NavigationButton(sheet: .groupDescription(group: group)){
                            GroupRow(group: group, presentHallImage: !isLoading)
                        }
                        .redacted(reason: isLoading ? .placeholder : [])
                        .shimmer(active: isLoading)
                        .disabled(isLoading)
                    }
                }
            }
        }
    }

    func sectionHeader(days: Set<DayRecurrenceType>) -> some View {
        Text(
            days.map { $0.localized.localized(locale: locale) }
                .joined(separator: ", ")
        )
        .font(theme.typography.sectionTitle)
        .foregroundStyle(theme.colors.textPrimary)
    }
}
