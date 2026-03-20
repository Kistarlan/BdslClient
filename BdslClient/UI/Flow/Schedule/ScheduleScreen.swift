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
        if viewModel.isLoading {
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

                FiltersView(viewModel: $viewModel)

                GroupListView(isLoading: viewModel.isLoading, groupSections: displayedSections)
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
