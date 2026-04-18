//
//  SubscriptionCardRow.swift
//  BdslClient
//

import Models
import Navigation
import SwiftUI

struct SubscriptionCardRow: View {
    let subscription: UserSubscription
    let isInitialized: Bool
    let isLoading: Bool

    var body: some View {
        NavigationButton(push: PushDestination.subsctiptionDetails(userSubscription: subscription)) {
            SubscriptionCard(subscription: subscription)
                .redacted(reason: !isInitialized ? .placeholder : [])
                .shimmer(active: !isInitialized)
        }
        .disabled(isLoading)
        .listRowBackground(Color.clear)
    }
}
