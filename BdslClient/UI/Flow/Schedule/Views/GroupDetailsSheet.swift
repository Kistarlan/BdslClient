//
//  GroupDetailsSheet.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 03.03.2026.
//

import SwiftUI
import Models
import DesignSystem
import Navigation

struct GroupDetailsSheet: View {
    @Environment(\.locale) private var locale
    @Environment(\.theme) private var theme

    private let navTitleHeight: CGFloat = 140
    @State private var contentHeight: CGFloat = 200

    let group: GroupModel

    var body: some View {
        ZStack {
            VStack(
                alignment: .leading,
                spacing: theme.layout.spacing.m
            ) {
                detailsRow(title: .style, value: group.activity.title)

                detailsRow(title: .level, value: group.level.title)

                detailsRow(title: .location, value: group.location.title)

                detailsRow(title: .address, value: group.location.address)

                detailsRow(
                    title: .teachers,
                    value: group.teachers
                        .map { $0.fullName }
                        .joined(separator: ", ")
                )

                detailsRow(
                    title: .days,
                    value: days
                )

                detailsRow(
                    title: .time,
                    value: time
                )

                Spacer()
            }
            .padding(theme.layout.spacing.ml)
        }
        .background(
            GeometryReader { proxy in
                Color.clear
                    .onAppear {
                        contentHeight = proxy.size.height
                    }
            }
        )
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(group.activity.title)
        .addDismissButton(.close)
        .presentationDetents([.height(contentHeight + navTitleHeight), .large])
    }

    func detailsRow(title: LocalizedStringResource, value: String) -> some View {
        HStack(alignment: .bottom, spacing: theme.layout.spacing.s) {

            Text("\(title.localized(locale: locale)):")
                .font(theme.typography.label)
                .foregroundStyle(theme.colors.textSecondary)

            Text(value)
                .font(theme.typography.body)
                .foregroundStyle(theme.colors.textPrimary)

            Spacer()
        }
    }

    var days: String {
        group.recurrence.days
            .sorted()
            .map { $0.localized.localized(locale: locale) }
            .joined(separator: ", ")
    }

    var time: String {
        "\(group.startDate.formatted(date: .omitted, time: .shortened))"
        + "– \(group.endDate.formatted(date: .omitted, time: .shortened))"
    }
}
