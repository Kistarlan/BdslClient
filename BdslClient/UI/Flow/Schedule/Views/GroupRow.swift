//
//  GroupRow.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 03.03.2026.
//

import SwiftUI
import Models
import DesignSystem

struct GroupRow: View {
    @Environment(\.theme) private var theme

    let group: GroupModel
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

extension GroupRow {
    var datesView: some View {
        VStack(alignment: .leading, spacing: theme.layout.spacing.s) {
            Text(
                group.startDate
                    .formatted(date: .omitted, time: .shortened)
            )
            Text(
                group.endDate
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
                group.teachers
                    .map { $0.name }
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
        theme.scheme == .dark ? group.location.color2Hex : group.location.colorHex
    }

    var infoTitle: String {
        "\(group.activity.title) \(group.level.title)"
    }
}
