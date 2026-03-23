//
//  MainTabView.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 23.01.2026.
//

import SwiftUI
import DesignSystem
import Navigation
import Models

struct MainTabView: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.theme) private var theme
    @Bindable var router: Router
    @State private var mainViewModel: MainViewModel

    init(
        router: Router,
        mainViewModel: MainViewModel
    ) {
        self.router = router
        _mainViewModel = State(initialValue: mainViewModel)
    }

    var body: some View {
        ZStack {
            TabView(selection: $router.selectedTab) {
                Tab(LocalizedStringKey("Schedule"), systemImage: "calendar", value: TabDestination.schedule) {
                    NavigationContainer(parentRouter: router,
                                        destination: Destination.tab(TabDestination.schedule)) {
                        ScheduleScreen(viewModel: mainViewModel.scheduleViewModel)
                            .toolbar(
                                appState.state.isAuthenticated ? .visible : .hidden,
                                for: .tabBar
                            )
                    }
                }

                if appState.state.isAuthenticated {
                    Tab(LocalizedStringKey("My Classes"), systemImage: "person.2.fill", value: TabDestination.myClasses) {
                        NavigationContainer(parentRouter: router,
                                            destination: Destination.tab(TabDestination.myClasses)) {
                            MyClassesScreen(viewModel: mainViewModel.myClassesViewModel)
                        }
                    }

                    Tab(LocalizedStringKey("Subscriptions"), systemImage: "creditcard", value: TabDestination.subscription) {
                        NavigationContainer(parentRouter: router,
                                            destination: Destination.tab(TabDestination.subscription)) {
                            SubscriptionsScreen(subscriptionsViewModel: mainViewModel.subscriptionsViewModel)
                        }
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
        mainViewModel: AppContainer.shared.viewModelsFactory.makePreviewMainViewModel()
    )
    .setupPreviewEnvironments()
}
