//
//  SubscriptionCard.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 19.02.2026.
//

import SwiftUI
import Models
import DesignSystem

struct SubscriptionCard: View {
    @Environment(\.locale) private var locale
    @Environment(\.theme) private var theme
    let subscription: UserSubscription

    var body: some View {
        HStack(alignment: .top, spacing: theme.layout.spacing.m) {
            VStack(alignment: .leading, spacing: theme.layout.spacing.xs) {
                Text(subscription.title)
                    .font(theme.typography.body.weight(.semibold))
                    .foregroundColor(theme.colors.textPrimary)

                description
            }

            Spacer()

            if let badgeLessonsCount = subscription.badgeLessonsCount {
                VStack {
                    Spacer()
                    RemainingCircle(
                        badgeLessonsCount: badgeLessonsCount,
                        category: subscription.category
                    )
                    Spacer()
                }
            }

            VStack {
                Spacer()
                chevron
                Spacer()
            }
        }
        .padding(theme.layout.spacing.m)
        .background(theme.colors.cardBackground)
        .cornerRadius(theme.layout.cornerRadius.m)
        .roundedBorder(
            radius: theme.layout.cornerRadius.m,
            borderColor: theme.colors.materialBorder
        )
    }
}

private extension SubscriptionCard {
    var chevron: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(theme.colors.textSecondary)
    }
}

private extension SubscriptionCard {
    var description : some View {
        VStack(alignment: .leading, spacing: theme.layout.spacing.xs) {
            Text(tintText)

            if let dateRange = subscription.dateRangeText(locale: locale) {
                Text(dateRange)
            }
        }
        .font(theme.typography.secondary)
        .foregroundColor(theme.colors.textSecondary)
    }

    var tintText: LocalizedStringResource {
        switch subscription.category {
        case .active, .expired: .regularSubscription
        case .credit: .creditLessons
        case .oneClassTicket: .oneTimeTicket
        case .volonteer: .volonteer
        }
    }
}

