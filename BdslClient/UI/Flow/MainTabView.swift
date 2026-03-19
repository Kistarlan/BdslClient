//
//  MainTabView.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 23.01.2026.
//

import SwiftUI
import DesignSystem
import Navigation

struct MainTabView: View {
    @Environment(\.theme) private var theme
    @Bindable var router: Router
    @State private var mainTabViewModel: MainTabViewModel

    init(
        router: Router,
        mainTabViewModel: MainTabViewModel
    ) {
        self.router = router
        _mainTabViewModel = State(initialValue: mainTabViewModel)
    }

    var body: some View {
        ZStack {
            TabView(selection: $router.selectedTab) {
                Tab(LocalizedStringKey("Schedule"), systemImage: "calendar", value: TabDestination.schedule) {
                    NavigationContainer(parentRouter: router,
                                        destination: Destination.tab(TabDestination.schedule)) {
                        ScheduleScreen(viewModel: mainTabViewModel.scheduleViewModel)
                    }
                }

                //TODO: find correct solution for lower versions
                Tab(LocalizedStringKey("Subscriptions"), systemImage: "creditcard", value: TabDestination.subscription) {
                    NavigationContainer(parentRouter: router,
                                        destination: Destination.tab(TabDestination.subscription)) {
                        SubscriptionsScreen(subscriptionsViewModel: mainTabViewModel.subscriptionsViewModel)
                    }
                }


            }
            .backport
            .tabBarMinimizeBehavior(.onScrollDown)
            .tint(theme.colors.accent)
        }
    }
}

#Preview {
    MainTabView(
        router: .init(level: 0, identifierDestination: nil),
        mainTabViewModel: AppContainer.shared.viewModelsFactory.makePreviewMainTabViewModel()
    )
    .setupPreviewEnvironments()
}
