//
//  ProfileSectionView.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 03.02.2026.
//

import DesignSystem
import Models
import SwiftUI

struct ProfileSectionView: View {
    @Environment(\.theme) private var theme
    let user: User

    var body: some View {
        HStack(spacing: theme.layout.spacing.m) {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 48, height: 48)
                .foregroundStyle(theme.colors.iconSecondary)

            VStack(alignment: .leading, spacing: theme.layout.spacing.xs) {
                Text(.welcome)
                    .font(.caption)
                    .foregroundStyle(theme.colors.textSecondary)

                Text(user.fullName)
                    .font(.headline)
                    .foregroundStyle(theme.colors.textPrimary)
            }

            Spacer()

            Image(systemName: "arrow.right.square")
                .foregroundStyle(theme.colors.accent)
        }
    }
}

#Preview {
    ProfileSectionView(user: UserDTO.previewValue().toDomain())
}
