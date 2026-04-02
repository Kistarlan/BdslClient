//
//  ScheduleScreen.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 27.02.2026.
//

import DesignSystem
import Models
import Navigation
import SwiftUI

struct ScheduleScreen: View {
    @Environment(\.theme) private var theme

    @State private var viewModel: ScheduleViewModel
    @Environment(AppState.self) private var appState

    var displayedSections: [ScheduleGroupSection] {
        if !viewModel.isInitialized {
            return [
                ScheduleGroupSection(
                    days: Set([DayRecurrenceType.monday]),
                    events: (0 ..< 5).map { _ in .placeholder() }
                )
            ]
        }

        return viewModel.groupSections
    }

    init(viewModel: ScheduleViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: theme.layout.spacing.m) {
                if let localizedError = viewModel.localizedError {
                    ErrorView(errorMessage: localizedError) {
                        Task {
                            await viewModel.loadEvents(forceReload: false)
                        }
                    }
                } else {
                    FiltersView(viewModel: $viewModel)

                    GroupListView(isLoading: !viewModel.isInitialized, groupSections: displayedSections)
                }
            }
            .padding()
        }
        .task {
            await viewModel.loadEvents(forceReload: false)
        }
        .navigationTitle(Text(.schedule))
        .toolbar {
            if !appState.state.isAuthenticated {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationButton(push: PushDestination.login) {
                        Text(.login)
                            .foregroundStyle(theme.colors.accent)
                    }
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                SettingsButton()
            }
        }
        .refreshable {
            if viewModel.isInitialized && !viewModel.isLoading {
                await viewModel.loadEvents(forceReload: true)
            }
        }
        .background(theme.colors.appBackground)
    }
}
