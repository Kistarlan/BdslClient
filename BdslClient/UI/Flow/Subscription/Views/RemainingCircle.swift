//
//  RemainingCircle.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 26.02.2026.
//

import SwiftUI
import Models
import DesignSystem

struct RemainingCircle: View {
    @Environment(\.theme) private var theme

    let badgeLessonsCount: Int
    let category: SubscriptionCategory

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
        switch category {
        case .active: theme.colors.accent
        case .credit: .red
        default: .clear
        }
    }
}
