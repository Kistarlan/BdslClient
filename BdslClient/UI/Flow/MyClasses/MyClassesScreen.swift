//
//  MyClassesScreen.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 23.03.2026.
//

import DesignSystem
import Models
import Navigation
import SwiftUI

struct MyClassesScreen: View {
    @Environment(\.theme) private var theme
    @Environment(\.locale) private var locale

    @State private var viewModel: MyClassesViewModel
    var displayedSections: [GroupedSection<Date, UpcomingClassModel>] {
        if !viewModel.isInitialized {
            [
                GroupedSection<Date, UpcomingClassModel>(
                    Date(),
                    (0 ..< 5).map { _ in UpcomingClassModel.placeholder() }
                )
            ]
        } else {
            viewModel.groupedClasses
        }
    }

    init(viewModel: MyClassesViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .leading) {
            if let localizedError = viewModel.localizedError {
                ErrorView(errorMessage: localizedError) {
                    Task {
                        await viewModel.loadClasses(forceReload: false)
                    }
                }
            } else {
                itemList
            }
        }
        .navigationTitle(Text(.myClasses))
        .background(theme.colors.appBackground)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                SettingsButton()
            }
        }
        .task {
            await viewModel.loadClasses(forceReload: false)
        }
        .refreshable {
            if viewModel.isInitialized && !viewModel.isLoading {
                await viewModel.loadClasses(forceReload: true)
            }
        }
    }
}

extension MyClassesScreen {
    var itemList: some View {
        List {
            ForEach(displayedSections) { group in
                classScetion(group)
            }
        }
        .listStyle(.plain)
        .listSectionSeparator(.hidden)
        .scrollContentBackground(.hidden)
        .background(theme.colors.appBackground)
    }

    func classScetion(_ section: GroupedSection<Date, UpcomingClassModel>) -> some View {
        Section {
            ForEach(section.items) { upcomingClass in
                NavigationButton(sheet: .eventDescription(event: upcomingClass.event)) {
                    ClassCard(
                        upcomingClass: upcomingClass,
                        presentHallImage: viewModel.isInitialized
                    )
                }
                .disabled(viewModel.isLoading)
                .listRowBackground(Color.clear)
                .redacted(reason: !viewModel.isInitialized ? .placeholder : [])
                .shimmer(active: !viewModel.isInitialized)
                .listRowSeparator(.hidden)
            }
        } header: {
            groupHeader(section.key)
                .headerProminence(.standard)
        }
        .listRowSeparator(.hidden)
    }

    func groupHeader(_ date: Date) -> some View {
        Group {
            if Calendar.current.isDateInToday(date) {
                Text(.today)
            } else if Calendar.current.isDateInTomorrow(date) {
                Text(.tomorrow)
            } else {
                Text(dayOfWeek(for: date))
            }
        }
        .font(theme.typography.label)
        .foregroundStyle(theme.colors.textSecondary)
        .textCase(.uppercase)
        .redacted(reason: !viewModel.isInitialized ? .placeholder : [])
        .shimmer(active: !viewModel.isInitialized)
    }

    func dayOfWeek(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.dateFormat = "EEEE"

        return formatter.string(from: date)
    }
}
