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

    var displayedSections: [ScheduleEventSection] {
        if viewModel.isLoading {
            return [
                ScheduleEventSection(days: Set([DayRecurrenceType.monday]),
                                     events: (0..<5).map { _ in .placeholder() })
            ]
        }

        return viewModel.eventSections
    }

    init(viewModel: ScheduleViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: theme.layout.spacing.m) {

                FiltersView(viewModel: $viewModel)

                EventListView(isLoading: viewModel.isLoading, eventSections: displayedSections)
            }
            .padding()
        }
        .task {
            if !viewModel.isLoaded {
                await viewModel.loadEvents()
            }
        }
        .navigationTitle(Text(.schedule))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing){
                SettingsButton()
            }
        }
        .background(theme.colors.appBackground)
    }
}
