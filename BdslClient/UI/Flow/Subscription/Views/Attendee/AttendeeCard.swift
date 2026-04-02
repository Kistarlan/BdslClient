//
//  AttendeeCard.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 26.02.2026.
//

import DesignSystem
import Models
import SwiftUI

struct AttendeeCard: View {
    @Environment(\.theme) private var theme

    let attendee: AttendeeModel

    init(attendee: AttendeeModel) {
        self.attendee = attendee
    }

    var body: some View {
        VStack(alignment: .leading, spacing: theme.layout.spacing.xs) {
            Text(attendee.event.title)
                .font(theme.typography.cardTitle)
                .foregroundStyle(theme.colors.textPrimary)

            if !attendee.event.teachers.isEmpty {
                Text(teachersText(for: attendee))
                    .font(theme.typography.secondary)
                    .foregroundStyle(theme.colors.textSecondary)
            }

            Text(
                attendee.enrollTime
                    .formatted(date: .abbreviated, time: .shortened)
            )
            .font(theme.typography.caption)
            .foregroundStyle(theme.colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(theme.layout.spacing.m)
        .background(theme.colors.cardBackground)
        .clipShape(.rect(cornerRadius: theme.layout.cornerRadius.m))
        .roundedBorder(
            radius: theme.layout.cornerRadius.m,
            borderColor: theme.colors.materialBorder
        )
    }

    func teachersText(for attendee: AttendeeModel) -> String {
        attendee.event.teachers
            .map { $0.user.fullName }
            .joined(separator: " & ")
    }
}

#Preview {
    AttendeeCard(
        attendee: AttendeeModel.placeholder()
    )
    .setupPreviewEnvironments(.dark)
}
