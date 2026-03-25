//
//  SubscriptionsScreen.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 19.02.2026.
//

import SwiftUI
import Models
import DesignSystem
import Navigation

struct SubscriptionsScreen: View {
    @Environment(\.theme) private var theme

    @Bindable private var viewModel: SubscriptionsViewModel
    var displayedGroups: [GroupedSection<SubscriptionGroupCategory, UserSubscription>] {
        if !viewModel.isInitialized {
            return [
                GroupedSection(.subscriptionCategory(.active),
                               (0..<5).map { _ in .placeholder() })
            ]
        }

        let grouped = viewModel.grouped
        return grouped
    }

    init(subscriptionsViewModel: SubscriptionsViewModel){
        viewModel = subscriptionsViewModel
    }

    var body: some View {
        VStack {
            if let localizedErrorMessage = viewModel.localizedError {
                ErrorView(errorMessage: localizedErrorMessage) {
                    Task {
                        await viewModel.fetchSubscriptions(forceReload: false)
                    }
                }
            } else {
                VStack {
                    List {
                        ForEach(displayedGroups) { group in
                            subscriptionsGroup(group: group)
                        }
                    }
                    .listStyle(.plain)
                    .listRowSeparator(.hidden)
                    .scrollContentBackground(.hidden)
                }
                .searchable(text: $viewModel.searchText)
            }

        }
        .navigationTitle(Text(LocalizedStringResource.mySubscriptions))
        .background(theme.colors.appBackground)
        .toolbar {
            ToolbarItem(placement: .topBarLeading){
                Button {
                    viewModel.togleGroupingMode()
                } label: {
                    Image(systemName:
                            viewModel.groupingMode == .category
                          ? "calendar"
                          : "square.grid.2x2"
                    )
                }
            }

            ToolbarItem(placement: .topBarTrailing){
                SettingsButton()
            }
        }
        .task {
            await viewModel.fetchSubscriptions(forceReload: false)
        }
        .refreshable {
            if viewModel.isInitialized && !viewModel.isLoading {
                await viewModel.fetchSubscriptions(forceReload: true)
            }
        }
    }

    func subscriptionsGroup(group: GroupedSection<SubscriptionGroupCategory, UserSubscription>) -> some View {
        Section() {
            ForEach(group.items) { subscription in
                subscriptionsCard(subscription)
            }
        } header: {
            groupHeader(group.key)
        }
        .listRowSeparator(.hidden)
    }

    func subscriptionsCard(_ subscription: UserSubscription) -> some View {
        return NavigationButton(push: PushDestination.subsctiptionDetails(userSubscription: subscription)){
            SubscriptionCard(
                subscription: subscription,
            )
            .redacted(reason: !viewModel.isInitialized ? .placeholder : [])
            .shimmer(active: !viewModel.isInitialized)
        }
        .disabled(viewModel.isLoading)
        .listRowBackground(Color.clear)
    }

    func groupHeader(_ groupCategory: SubscriptionGroupCategory) -> some View {
        Group {
            switch groupCategory {
            case .date(let date):
                Text(date, format: .dateTime.month(.wide).year())
            case .subscriptionCategory(let subscriptionCategory):
                Text(subscriptionCategory.title)
            }
        }
        .font(theme.typography.label)
        .foregroundStyle(theme.colors.textSecondary)
        .textCase(.uppercase)
    }
}
