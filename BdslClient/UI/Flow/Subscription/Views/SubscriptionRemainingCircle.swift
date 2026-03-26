//
//  SubscriptionRemainingCircle.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 26.02.2026.
//

import DesignSystem
import Models
import SwiftUI

struct SubscriptionRemainingCircle: View {
    @Environment(\.theme) private var theme

    let badgeLessonsCount: Int
    let userSubscription: UserSubscription

    var body: some View {
        ZStack {
            Circle()
                .fill(circleColor)
                .frame(width: 32, height: 32)

            Text("\(badgeLessonsCount)")
                .font(theme.typography.label)
                .foregroundColor(.white)
        }
    }

    var circleColor: Color {
        switch userSubscription.category {
        case .active: userSubscription.isExpiredSoon ? theme.colors.badgeWarning : theme.colors.badgeActive
        case .credit: theme.colors.badgeCredit
        default: .clear
        }
    }
}
