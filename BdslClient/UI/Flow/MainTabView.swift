//
//  MainTabView.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 23.01.2026.
//

import DesignSystem
import Models
import Navigation
import SwiftUI

struct MainTabView: View {
    @Environment(AppState.self) private var appState
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
                    scheduleTabContent
                }

                if appState.state.isAuthenticated {
                    Tab(
                        LocalizedStringKey("My Classes"),
                        systemImage: "person.2.fill",
                        value: TabDestination.myClasses
                    ) {
                        myClassesTabContent
                    }

                    Tab(
                        LocalizedStringKey("Subscriptions"),
                        systemImage: "creditcard",
                        value: TabDestination.subscription
                    ) {
                        subscriptionTabContent
                    }
                }
            }
            .backport
            .tabBarMinimizeBehavior(.onScrollDown)
            .tint(theme.colors.accent)
        }
    }
}

private extension MainTabView {
    var subscriptionTabContent: some View {
        NavigationContainer(
            parentRouter: router,
            destination: Destination.tab(TabDestination.subscription)
        ) {
            SubscriptionsScreen(subscriptionsViewModel: mainViewModel.subscriptionsViewModel)
        }
    }

    var myClassesTabContent: some View {
        NavigationContainer(
            parentRouter: router,
            destination: Destination.tab(TabDestination.myClasses)
        ) {
            MyClassesScreen(viewModel: mainViewModel.myClassesViewModel)
        }
    }

    var scheduleTabContent: some View {
        NavigationContainer(
            parentRouter: router,
            destination: Destination.tab(TabDestination.schedule)
        ) {
            Group {
                if appState.state.isAuthenticated {
                    ScheduleScreen(viewModel: mainViewModel.scheduleViewModel)
                } else {
                    ScheduleScreen(viewModel: mainViewModel.scheduleViewModel)
                        .toolbar(.hidden, for: .tabBar)
                }
            }
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
