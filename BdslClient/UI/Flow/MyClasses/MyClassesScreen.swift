//
//  MyClassesScreen.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 23.03.2026.
//

import SwiftUI
import Models
import DesignSystem
import Navigation

struct MyClassesScreen: View {
    @Environment(\.theme) private var theme
    @Environment(\.locale) private var locale

    @State private var viewModel: MyClassesViewModel
    var displayedSections: [GroupedSection<Date, UpcomingClassModel>] {
        if !viewModel.isInitialized {
            return [
                GroupedSection<Date, UpcomingClassModel>(
                    Date(),
                    (0..<5).map { _ in UpcomingClassModel.placeholder() }
                )
            ]
        }

        return viewModel.groupedClasses
    }

    init(viewModel: MyClassesViewModel){
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .leading) {
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
        .navigationTitle(Text(.myClasses))
        .background(theme.colors.appBackground)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing){
                SettingsButton()
            }
        }
        .task {
            await viewModel.loadSubscriptions(forceReload: false)
        }
        .refreshable {
            if viewModel.isInitialized && !viewModel.isLoading {
                await viewModel.loadSubscriptions(forceReload: true)
            }
        }
    }
}

extension MyClassesScreen {

    func classScetion(_ section: GroupedSection<Date, UpcomingClassModel>) -> some View {
        Section() {
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
