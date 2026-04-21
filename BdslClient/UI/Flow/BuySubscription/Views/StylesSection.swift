//
//  StylesSection.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 21.04.2026.
//

import DesignSystem
import Models
import SwiftUI

struct StylesSection: View {
    var viewModel: BuySubscriptionViewModel

    var body: some View {
        SubscriptionSelectionSection(title: .styles) {
            FilterChip(localizedTitle: .unlimitedMonth, isSelected: viewModel.isUnlim) {
                viewModel.toggleUnlim()
            }

            ForEach(viewModel.displayedStyles) { activity in
                FilterChip(
                    title: activity.title,
                    isSelected: viewModel.selectedActivityIds.contains(activity.id)
                ) {
                    viewModel.toggleActivity(activity.id)
                }
            }
        }
        .redacted(reason: !viewModel.isInitialized ? .placeholder : [])
        .shimmer(active: !viewModel.isInitialized)
        .disabled(!viewModel.isInitialized)
    }
}
