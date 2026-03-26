//
//  ClassCard.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 23.03.2026.
//

import DesignSystem
import Models
import SwiftUI

struct ClassCard: View {
    @Environment(\.theme) private var theme

    let upcomingClass: UpcomingClassModel
    let presentHallImage: Bool

    var body: some View {
        HStack(alignment: .top, spacing: theme.layout.spacing.s) {
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

extension ClassCard {
    var datesView: some View {
        VStack(alignment: .leading, spacing: theme.layout.spacing.s) {
            Text(
                upcomingClass.event.startDate
                    .formatted(date: .omitted, time: .shortened)
            )
            Text(
                upcomingClass.event.endDate
                    .formatted(date: .omitted, time: .shortened)
            )
        }
        .font(theme.typography.secondary)
        .foregroundStyle(theme.colors.textSecondary)
    }

    var infoView: some View {
        VStack(alignment: .leading, spacing: theme.layout.spacing.s) {
            Text(infoTitle)
                .font(theme.typography.cardTitle)
                .foregroundStyle(theme.colors.textPrimary)

            Text(
                upcomingClass.event.teachers
                    .map { $0.user.name }
                    .joined(separator: ", ")
            )
            .font(theme.typography.caption)
            .foregroundStyle(theme.colors.textSecondary)
        }
    }

    var imageView: some View {
        VStack {
            Spacer()
            Image(systemName: "house.fill")
                .font(theme.typography.caption)
                .foregroundStyle(Color(hex: houseColorHex))
            Spacer()
        }
    }

    private var houseColorHex: String {
        theme.scheme == .dark ? upcomingClass.event.location.color2Hex : upcomingClass.event.location.colorHex
    }

    var infoTitle: String {
        "\(upcomingClass.event.activity.title) \(upcomingClass.event.level.title)"
    }
}
