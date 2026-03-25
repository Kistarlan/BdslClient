//
//  ScheduleScreen.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 27.02.2026.
//

import SwiftUI
import DesignSystem
import Navigation
import Models

struct ScheduleScreen: View {
    @Environment(\.theme) private var theme

    @State private var viewModel: ScheduleViewModel

    var displayedSections: [ScheduleGroupSection] {
        if !viewModel.isInitialized {
            return [
                ScheduleGroupSection(days: Set([DayRecurrenceType.monday]),
                                     events: (0..<5).map { _ in .placeholder() })
            ]
        }

        return viewModel.groupSections
    }

    init(viewModel: ScheduleViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: theme.layout.spacing.m) {
                if let localizedError = viewModel.localizedError {
                    ErrorView(errorMessage: localizedError) {
                        Task {
                            await viewModel.loadEvents(forceReload: false)
                        }
                    }
                } else {
                    VStack {
                        FiltersView(viewModel: $viewModel)

                        GroupListView(isLoading: !viewModel.isInitialized, groupSections: displayedSections)
                    }
                }
            }
            .padding()
        }
        .task {
            await viewModel.loadEvents(forceReload: false)
        }
        .navigationTitle(Text(.schedule))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing){
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
