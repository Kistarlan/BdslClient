//
//  FiltersView.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 05.03.2026.
//

import SwiftUI
import DesignSystem
import Models

struct FiltersView: View {
    @Environment(\.theme) private var theme

    @State private var isFilterExpanded = false
    @Binding private var viewModel: ScheduleViewModel

    init(viewModel: Binding<ScheduleViewModel>) {
        self._viewModel = viewModel
    }

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: theme.layout.spacing.sm
        ) {

            header
                .redacted(reason: viewModel.isLoading ? .placeholder : [])
                .shimmer(active: viewModel.isLoading)
                .disabled(viewModel.isLoading)

            if isFilterExpanded && !viewModel.isLoading {
                filterSections
            }
        }
        .padding(theme.layout.spacing.m)
        .background(theme.colors.cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: theme.layout.cornerRadius.l)
                .stroke(theme.colors.materialBorder)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: theme.layout.cornerRadius.l)
        )
    }
}

private extension FiltersView {

    var header: some View {
        HStack {
            HStack {
                Text(.filters)
                    .font(theme.typography.sectionTitle)
                    .foregroundStyle(theme.colors.textPrimary)

                Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    isFilterExpanded.toggle()
                }
            }

            if !viewModel.filters.isEmpty {
                Button {
                    viewModel.resetFilters()
                } label: {
                    Text(.reset)
                        .font(theme.typography.caption)
                        .foregroundStyle(theme.colors.accent)
                }
                .buttonStyle(.plain)
            }

            // Chevron (окремо!)
            if !viewModel.isLoading {
                Image(systemName: "chevron.down")
                    .rotationEffect(.degrees(isFilterExpanded ? 0 : -90))
                    .foregroundStyle(theme.colors.iconSecondary)
                    .padding(.leading, theme.layout.spacing.xs)
                    .onTapGesture {
                        withAnimation {
                            isFilterExpanded.toggle()
                        }
                    }
            }
        }
        .padding(.vertical, theme.layout.spacing.xs)
    }
}

private extension FiltersView {
    var filterSections: some View {
        VStack(
            alignment: .leading,
            spacing: theme.layout.spacing.sm
        ) {
            FilterBlock(
                title: .styles,
                items: viewModel.availableActivities,
                selection: $viewModel.filters.selectedActivityIds,
                id: \.id,
                titleKey: \.title,
                isExpanded: viewModel.expandedFilter == .activity,
                onHeaderTap: { viewModel.toggle(.activity) }
            )

            FilterBlock(
                title: .locations,
                items: viewModel.availableLocations,
                selection: $viewModel.filters.selectedLocationIds,
                id: \.id,
                titleKey: \.title,
                isExpanded: viewModel.expandedFilter == .location,
                onHeaderTap: { viewModel.toggle(.location) }
            )

            FilterBlock(
                title: .teachers,
                items: viewModel.availableTeachers,
                selection: $viewModel.filters.selectedTeacherIds,
                id: \.id,
                titleKey: \.user.fullName,
                isExpanded: viewModel.expandedFilter == .teacher,
                onHeaderTap: { viewModel.toggle(.teacher) }
            )

            DayFilterBlock(
                title: .days,
                items: viewModel.availableDays,
                selection: $viewModel.filters.selectedDays,
                isExpanded: viewModel.expandedFilter == .day,
                onHeaderTap: { viewModel.toggle(.day) }
            )
        }
        .padding(.leading, theme.layout.spacing.s)
    }
}
