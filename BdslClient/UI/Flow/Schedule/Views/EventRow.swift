//
//  EventRow.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 03.03.2026.
//

import SwiftUI
import Models
import DesignSystem

struct EventRow: View {
    @Environment(\.theme) private var theme

    let event: EventModel
    let presentHallImage: Bool

    var body: some View {
        HStack(spacing: theme.layout.spacing.s) {

            datesView

            infoView

            Spacer()

            if presentHallImage {
                imageView
            }
        }
        .padding(theme.layout.spacing.m)
        .background(theme.colors.cardBackground)
        .clipShape(
            RoundedRectangle(
                cornerRadius: theme.layout.cornerRadius.m
            )
        )
    }
}

extension EventRow {
    var datesView: some View {
        VStack(alignment: .leading, spacing: theme.layout.spacing.s) {
            Text(
                event.startDate
                    .formatted(date: .omitted, time: .shortened)
            )
            Text(
                event.endDate
                    .formatted(date: .omitted, time: .shortened)
            )
        }
        .font(theme.typography.secondary)
        .foregroundStyle(theme.colors.textSecondary)
    }

    var infoView: some View {
        VStack(alignment: .leading, spacing: theme.layout.spacing.s) {
            Text(event.activity.title)
                .font(theme.typography.cardTitle)
                .foregroundStyle(theme.colors.textPrimary)

            Text(
                event.teachers
                    .map { $0.user.fullName }
                    .joined(separator: ", ")
            )
            .font(theme.typography.caption)
            .foregroundStyle(theme.colors.textSecondary)
        }
    }

    var imageView: some View {
        Image(systemName: "house.fill")
            .font(theme.typography.caption)
            .foregroundStyle(Color(hex: houseColorHex))
    }

    private var houseColorHex : String {
        theme.scheme == .dark ? event.location.color2Hex : event.location.colorHex
    }
}
