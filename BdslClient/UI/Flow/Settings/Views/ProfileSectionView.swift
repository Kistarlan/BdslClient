//
//  ProfileSectionView.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 03.02.2026.
//

import Models
import SwiftUI

struct ProfileSectionView: View {
    let user: User

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 48, height: 48)
                .foregroundStyle(.gray)

            VStack(alignment: .leading, spacing: 4) {
                Text(.welcome)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(user.fullName)
                    .font(.headline)
            }

            Spacer()

            Image(systemName: "arrow.right.square")
                .foregroundStyle(.blue)
        }
    }
}

#Preview {
    ProfileSectionView(user: UserDTO.previewValue().toDomain())
}
