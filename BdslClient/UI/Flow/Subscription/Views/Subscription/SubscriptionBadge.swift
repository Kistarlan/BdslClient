//
//  SubscriptionBadge.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 26.02.2026.
//

import DesignSystem
import Models
import SwiftUI

struct SubscriptionBadge: View {
    @Environment(\.theme) private var theme

    let userSubscription: UserSubscription

    var body: some View {
        ZStack {
            if let title = localizedTitle {
                Text(title)
                    .font(theme.typography.label)
                    .foregroundStyle(.white)
                    .padding(.horizontal, theme.layout.spacing.s)
                    .padding(.vertical, theme.layout.spacing.xs)
                    .background(backgroundColor)
                    .clipShape(Capsule())
            }
        }
    }

    private var localizedTitle: LocalizedStringResource? {
        switch userSubscription.category {
        case .active:
            return userSubscription.isExpiredSoon ? .expiring : .active
        case .credit:
            if let closed = userSubscription.closed, closed {
                return .inactive
            } else {
                return .activeCredit
            }
        case .expired, .oneClassTicket:
            return .inactive
        default:
            return nil
        }
    }

    private var backgroundColor: Color {
        switch userSubscription.category {
        case .active:
            return userSubscription.isExpiredSoon ? theme.colors.badgeWarning : theme.colors.badgeActive
        case .credit:
            if let closed = userSubscription.closed, closed {
                return theme.colors.badgeInactive
            } else {
                return theme.colors.badgeCredit
            }
        case .expired, .oneClassTicket:
            return theme.colors.badgeInactive
        default:
            return .clear
        }
    }
}
