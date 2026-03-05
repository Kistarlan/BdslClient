//
//  EventDetailsSheet.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 03.03.2026.
//

import SwiftUI
import Models
import DesignSystem
import Navigation

struct EventDetailsSheet: View {
    @Environment(\.locale) private var locale
    @Environment(\.theme) private var theme

    private let navTitleHeight: CGFloat = 140
    @State private var contentHeight: CGFloat = 200

    let event: EventModel

    var body: some View {
        ZStack {
            VStack(
                alignment: .leading,
                spacing: theme.layout.spacing.m
            ) {
                detailsRow(title: .style, value: event.activity.title)

                detailsRow(title: .level, value: event.level.title)

                detailsRow(title: .location, value: event.location.title)

                detailsRow(title: .address, value: event.location.address)

                detailsRow(
                    title: .teachers,
                    value: event.teachers
                        .map { $0.user.fullName }
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
        .navigationTitle(event.activity.title)
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
        event.weeklyReccurance.days
            .sorted()
            .map { $0.localized.localized(locale: locale) }
            .joined(separator: ", ")
    }

    var time: String {
        "\(event.startDate.formatted(date: .omitted, time: .shortened))"
        + "– \(event.endDate.formatted(date: .omitted, time: .shortened))"
    }
}
