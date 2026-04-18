//
//  SubscriptionsScreen.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 19.02.2026.
//

import DesignSystem
import Models
import Navigation
import SwiftUI

struct SubscriptionsScreen: View {
    @Environment(\.theme) private var theme

    @Bindable private var viewModel: SubscriptionsViewModel

    init(subscriptionsViewModel: SubscriptionsViewModel) {
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
                        ForEach(viewModel.displayedGroups) { group in
                            SubscriptionGroupRow(
                                group: group,
                                isInitialized: viewModel.isInitialized,
                                isLoading: viewModel.isLoading
                            )
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
            ToolbarItem(placement: .topBarLeading) {
                Button(action: viewModel.togleGroupingMode) {
                    Label {
                        Text(viewModel.groupingMode == .category ? LocalizedStringResource.groupByDate : .groupByCategory)
                    } icon: {
                        Image(systemName: viewModel.groupingMode == .category ? "calendar" : "square.grid.2x2")
                    }
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
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

}
