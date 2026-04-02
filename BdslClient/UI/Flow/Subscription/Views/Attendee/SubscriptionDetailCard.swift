//
//  SubscriptionDetailCard.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 26.02.2026.
//

import DesignSystem
import Models
import SwiftUI

struct SubscriptionDetailCard: View {
    @Environment(\.locale) private var locale
    @Environment(\.theme) private var theme
    @State private var userSubscription: UserSubscription

    init(subscription: UserSubscription) {
        userSubscription = subscription
    }

    var body: some View {
        VStack(alignment: .leading, spacing: theme.layout.spacing.s) {
            Text(userSubscription.title)
                .font(theme.typography.sectionTitle)
                .foregroundStyle(theme.colors.textPrimary)

            SubscriptionBadge(userSubscription: userSubscription)

            if let metaText = subscriptionMetaText {
                Text(metaText)
                    .font(theme.typography.body)
                    .foregroundStyle(theme.colors.textSecondary)
            }

            if !userSubscription.activities.isEmpty {
                activities
            }

            if let dateText = userSubscription.dateRangeText(locale: locale) {
                Text(dateText)
                    .font(theme.typography.caption)
                    .foregroundStyle(theme.colors.textSecondary)
            }
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
}

extension SubscriptionDetailCard {
    private var activities: some View {
        HStack {
            ForEach(userSubscription.activities) { activity in
                Text(activity.title)
                    .font(theme.typography.caption)
                    .foregroundStyle(theme.colors.secondaryChipText)
                    .padding(.horizontal, theme.layout.spacing.s)
                    .padding(.vertical, theme.layout.spacing.xs)
                    .background(Color(hex: activity.colorHex))
                    .clipShape(Capsule())
            }
        }
    }

    private var subscriptionMetaText: String? {
        [
            userSubscription.price.map { "₴ \($0.formatted())" },
            userSubscription.paymentMethod?.localized.localized(locale: locale)
        ]
        .compactMap { $0 }
        .joined(separator: ", ")
        .nilIfEmpty
    }
}

#Preview {
    VStack {
        SubscriptionDetailCard(
            subscription: UserSubscription.placeholder()
        )
    }
    .setupPreviewEnvironments(.dark)
}
