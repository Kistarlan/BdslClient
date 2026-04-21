//
//  BuySubscriptionScreen.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 21.04.2026.
//

import DesignSystem
import SwiftUI

struct BuySubscriptionScreen: View {
    @Environment(\.theme) private var theme
    @State private var viewModel: BuySubscriptionViewModel

    init(viewModel: BuySubscriptionViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        @Bindable var vm = viewModel

        ScrollView {
            LazyVStack(spacing: theme.layout.spacing.m) {
                if let error = viewModel.localizedError {
                    ErrorView(errorMessage: error) {
                        Task { await viewModel.load() }
                    }
                } else {
                    DirectionsSection(viewModel: viewModel)

                    if viewModel.showCoursesSection {
                        CoursesSection(viewModel: viewModel)
                    }

                    SubscriptionPriceCard(viewModel: viewModel)
                }
            }
            .padding(theme.layout.spacing.m)
        }
        .task { await viewModel.load() }
        .navigationTitle(Text(.buySubscription))
        .toolbar(.hidden, for: .tabBar)
        .background(theme.colors.appBackground)
        .sheet(isPresented: $vm.isShowingInvoice) {
            if let url = viewModel.invoiceUrl {
                InvoiceWebView(url: url)
                    .ignoresSafeArea()
            }
        }
        .alert(Text(.orderFailed), isPresented: $vm.isShowingOrderError) {
            Button("OK") {}
        }
    }
}
