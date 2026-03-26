//
//  SettingsRowView.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 03.02.2026.
//

import DesignSystem
import Navigation
import SwiftUI

struct SettingsRowView: View {
    @Environment(\.theme) private var theme

    let leftIcon: String?
    let rightIcon: String
    let title: LocalizedStringResource
    let value: String?
    let localizedValue: LocalizedStringResource?
    let destination: Destination

    init(
        leftIcon: String? = nil,
        title: LocalizedStringResource,
        value: String? = nil,
        localizedValue: LocalizedStringResource? = nil,
        rightIcon: String = "chevron.right",
        destination: Destination
    ) {
        self.leftIcon = leftIcon
        self.title = title
        self.value = value
        self.localizedValue = localizedValue
        self.destination = destination
        self.rightIcon = rightIcon
    }

    var body: some View {
        NavigationButton(destination: destination) {
            HStack {
                if let icon = leftIcon {
                    Image(systemName: icon)
                        .frame(width: 24)
                        .foregroundColor(.gray)
                }

                Text(title)
                    .font(theme.typography.body)
                    .tint(theme.colors.textPrimary)

                Spacer()

                if let unwrappedValue = value {
                    Text(unwrappedValue)
                        .font(theme.typography.body)
                        .tint(theme.colors.textPrimary)
                } else if let unwrappedLocalizedValue = localizedValue {
                    Text(unwrappedLocalizedValue)
                        .font(theme.typography.body)
                        .tint(theme.colors.textPrimary)
                }

                Image(systemName: rightIcon)
                    .foregroundColor(theme.colors.textSecondary)
            }
            .padding(theme.layout.spacing.m)
        }
    }
}

#Preview {
    SettingsRowView(
        leftIcon: "person",
        title: "User Profile",
        value: "value",
        destination: .push(.languageSettings)
    )
    .setupPreviewEnvironments()
}
