//
//  SubscriptionPriceCard.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 21.04.2026.
//

import DesignSystem
import SwiftUI

struct SubscriptionPriceCard: View {
    @Environment(\.theme) private var theme
    var viewModel: BuySubscriptionViewModel

    var body: some View {
        VStack(spacing: theme.layout.spacing.sm) {
            if viewModel.hasSelection {
                HStack {
                    Text(.totalPrice)
                        .font(theme.typography.sectionTitle)
                        .foregroundStyle(theme.colors.textPrimary)

                    Spacer()

                    Text("\(viewModel.calculatedPrice) ₴")
                        .font(theme.typography.sectionTitle)
                        .foregroundStyle(theme.colors.accent)
                }
            }

            Button {
                Task { await viewModel.requestOrder() }
            } label: {
                HStack(spacing: theme.layout.spacing.s) {
                    if viewModel.isOrdering {
                        ProgressView()
                            .tint(theme.colors.buttonPrimaryForeground)
                    }

                    Text(.placeOrder)
                        .font(theme.typography.button)
                        .foregroundStyle(theme.colors.buttonPrimaryForeground)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, theme.layout.spacing.sm)
                .background(
                    viewModel.hasSelection
                        ? theme.colors.buttonPrimaryBackground
                        : theme.colors.buttonPrimaryBackground.opacity(0.4)
                )
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            .disabled(!viewModel.hasSelection || viewModel.isOrdering)
        }
        .padding(theme.layout.spacing.m)
        .background(theme.colors.cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: theme.layout.cornerRadius.l)
                .stroke(theme.colors.materialBorder)
        )
        .clipShape(RoundedRectangle(cornerRadius: theme.layout.cornerRadius.l))
    }
}
