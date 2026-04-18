//
//  SubscriptionGroupHeader.swift
//  BdslClient
//

import DesignSystem
import Models
import SwiftUI

struct SubscriptionGroupHeader: View {
    @Environment(\.theme) private var theme

    let groupCategory: SubscriptionGroupCategory

    var body: some View {
        Group {
            switch groupCategory {
            case let .date(date):
                Text(date, format: .dateTime.month(.wide).year())
            case let .subscriptionCategory(subscriptionCategory):
                Text(subscriptionCategory.title)
            }
        }
        .font(theme.typography.label)
        .foregroundStyle(theme.colors.textSecondary)
        .textCase(.uppercase)
    }
}
