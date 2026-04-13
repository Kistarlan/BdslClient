//
//  ProfileHeaderView.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 06.02.2026.
//

import DesignSystem
import Models
import SwiftUI

struct ProfileHeaderView: View {
    @Environment(\.theme) private var theme

    let user: User
    let avatarImage: UIImage?

    init(
        user: User,
        avatarImage: UIImage? = nil
    ) {
        self.user = user
        self.avatarImage = avatarImage
    }

    var body: some View {
        VStack(spacing: theme.layout.spacing.m) {
            if let avatar = avatarImage {
                Image(uiImage: avatar)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 96, height: 96)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 96, height: 96)
                    .foregroundStyle(theme.colors.iconSecondary)
                    .clipShape(Circle())
            }

            Text(user.fullName)
                .multilineTextAlignment(.center)
                .font(theme.typography.screenTitle)
                .fontWeight(.semibold)
                .foregroundStyle(theme.colors.textPrimary)

            Text(profileDescription)
                .font(.subheadline)
                .foregroundStyle(theme.colors.textSecondary)

            if let email = user.contacts.email, !email.isEmpty {
                Text(email)
                    .font(.subheadline)
                    .foregroundStyle(theme.colors.textSecondary)
            }
        }
    }

    private var profileDescription: String {
        [
            user.contacts.phone,
            user.contacts.telegram
        ]
        .compactMap { $0 }
        .joined(separator: " • ")
    }
}

#Preview {
    ZStack {
        BackgroundView()
            .setupPreviewEnvironments(.light)
        ProfileHeaderView(user: UserDTO.previewValue().toDomain())
            .setupPreviewEnvironments(.light)
    }
}
