//
//  SubscriptionGroupRow.swift
//  BdslClient
//

import Models
import SwiftUI

struct SubscriptionGroupRow: View {
    let group: GroupedSection<SubscriptionGroupCategory, UserSubscription>
    let isInitialized: Bool
    let isLoading: Bool

    var body: some View {
        Section {
            ForEach(group.items) { subscription in
                SubscriptionCardRow(
                    subscription: subscription,
                    isInitialized: isInitialized,
                    isLoading: isLoading
                )
            }
        } header: {
            SubscriptionGroupHeader(groupCategory: group.key)
        }
        .listRowSeparator(.hidden)
    }
}
