//
//  ScheduleViewModel.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 02.03.2026.
//

import SwiftUI
import OSLog
import Models
import Services

@MainActor
@Observable
final class ScheduleViewModel {
    private let logger = Logger.forCategory(String(describing: ScheduleViewModel.self))
    private let groupsService: GroupsService

    private var allGroups: [GroupModel] = []

    var expandedFilter: ScheduleFilterType?
    var filters = ScheduleFilters()
    var isLoading = false
    var isLoaded: Bool = false

    init(groupsService: GroupsService) {
        self.groupsService = groupsService
    }

    // MARK: - Loading

    func loadEvents() async {
        isLoading = true
        defer { isLoading = false }

        do {
            allGroups = try await groupsService.fetchGroups(forceReload: false)
            isLoaded = true
        } catch {
            logger.warning("Can't load events: \(error)")
        }
    }

    // MARK: - Filters

    func resetFilters() {
        filters = ScheduleFilters()
    }

    // MARK: - Sections

    var eventSections: [ScheduleGroupSection] {

        Dictionary(grouping: filterGroups(allGroups)) {
            Set($0.recurrence.days.sorted())
        }
        .map { days, groups in
            ScheduleGroupSection(
                days: days,
                events: groups.sorted { $0.startDate < $1.startDate }
            )
        }
        .sorted {
            (
                $0.sortedDays.first ?? .monday,
                $0.sortedDays.count
            ) <
                (
                    $1.sortedDays.first ?? .monday,
                    $1.sortedDays.count
                )
        }
    }

    // MARK: - Available Filters (Faceted)

    var availableLocations: [Location] {
        unique(groupsFiltered(excluding: .location)) { $0.location }
            .sorted { $0.title < $1.title }
    }

    var availableActivities: [Activity] {
        unique(groupsFiltered(excluding: .activity)) { $0.activity }
            .sorted { $0.title < $1.title }
    }

    var availableTeachers: [GroupTeacher] {
        unique(
            groupsFiltered(excluding: .teacher)
                .flatMap { $0.teachers }
        ) { $0.id }
            .sorted { $0.fullName < $1.fullName }
    }

    var availableDays: [DayRecurrenceType] {
        Array(
            Set(
                groupsFiltered(excluding: .day)
                    .flatMap { $0.recurrence.days }
            )
        )
        .sorted()
    }

    // MARK: - Core Filtering

    func toggle(_ filter: ScheduleFilterType) {
        withAnimation {
            if expandedFilter == filter {
                expandedFilter = nil
            } else {
                expandedFilter = filter
            }
        }
    }

    private func filterGroups(_ groups: [GroupModel]) -> [GroupModel] {

        groups.filter { group in

            if !filters.selectedLocationIds.isEmpty &&
                !filters.selectedLocationIds.contains(group.location.id) {
                return false
            }

            if !filters.selectedActivityIds.isEmpty &&
                !filters.selectedActivityIds.contains(group.activity.id) {
                return false
            }

            if !filters.selectedTeacherIds.isEmpty {

                let teacherIds = Set(group.teachers.map(\.id))

                if filters.selectedTeacherIds.isDisjoint(with: teacherIds) {
                    return false
                }
            }

            if !filters.selectedDays.isEmpty {

                if Set(group.recurrence.days)
                    .isDisjoint(with: filters.selectedDays) {
                    return false
                }
            }

            return true
        }
    }

    // MARK: - Faceted filtering helper

    private func groupsFiltered(excluding filter: ScheduleFilterType) -> [GroupModel] {

        allGroups.filter { group in

            if filter != .location {
                if !filters.selectedLocationIds.isEmpty &&
                    !filters.selectedLocationIds.contains(group.location.id) {
                    return false
                }
            }

            if filter != .activity {
                if !filters.selectedActivityIds.isEmpty &&
                    !filters.selectedActivityIds.contains(group.activity.id) {
                    return false
                }
            }

            if filter != .teacher {
                if !filters.selectedTeacherIds.isEmpty {

                    let teacherIds = Set(group.teachers.map(\.id))

                    if filters.selectedTeacherIds.isDisjoint(with: teacherIds) {
                        return false
                    }
                }
            }

            if filter != .day {
                if !filters.selectedDays.isEmpty {

                    if Set(group.recurrence.days)
                        .isDisjoint(with: filters.selectedDays) {
                        return false
                    }
                }
            }

            return true
        }
    }

    // MARK: - Utilities

    private func unique<T: Hashable>(
        _ items: [GroupModel],
        key: (GroupModel) -> T
    ) -> [T] {

        Array(Set(items.map(key)))
    }

    private func unique<T: Hashable>(
        _ items: [T],
        key: (T) -> some Hashable
    ) -> [T] {

        Array(
            Dictionary(grouping: items, by: key)
                .compactMap { $0.value.first }
        )
    }
}
