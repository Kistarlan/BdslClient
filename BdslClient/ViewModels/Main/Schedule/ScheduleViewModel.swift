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
    private let eventsService: EventsService

    private var allEvents: [EventModel] = []

    var expandedFilter: ScheduleFilterType?
    var filters = ScheduleFilters()
    var isLoading = false
    var isLoaded: Bool = false

    init(eventsService: EventsService) {
        self.eventsService = eventsService
    }

    // MARK: - Loading

    func loadEvents() async {
        isLoading = true
        defer { isLoading = false }

        do {
            allEvents = try await eventsService.fetchActualEvents(forceReload: false)
            isLoaded = true
        } catch {
            logger.warning("Can't load events: \(error)")
        }
    }

    // MARK: - Filters

    func resetFilters() {
        filters = ScheduleFilters()
    }

    // MARK: - Filtered Events

    var filteredEvents: [EventModel] {
        filterEvents(allEvents)
    }

    // MARK: - Sections

    var eventSections: [ScheduleEventSection] {

        Dictionary(grouping: filteredEvents) {
            Set($0.weeklyReccurance.days.sorted())
        }
        .map { days, events in
            ScheduleEventSection(
                days: days,
                events: events.sorted { $0.startDate < $1.startDate }
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
        unique(eventsFiltered(excluding: .location)) { $0.location }
            .sorted { $0.title < $1.title }
    }

    var availableActivities: [Activity] {
        unique(eventsFiltered(excluding: .activity)) { $0.activity }
            .sorted { $0.title < $1.title }
    }

    var availableTeachers: [TeacherModel] {
        unique(
            eventsFiltered(excluding: .teacher)
                .flatMap { $0.teachers }
        ) { $0.id }
            .sorted { $0.user.fullName < $1.user.fullName }
    }

    var availableDays: [DayRecurrenceType] {
        Array(
            Set(
                eventsFiltered(excluding: .day)
                    .flatMap { $0.weeklyReccurance.days }
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

    private func filterEvents(_ events: [EventModel]) -> [EventModel] {

        events.filter { event in

            if !filters.selectedLocationIds.isEmpty &&
                !filters.selectedLocationIds.contains(event.location.id) {
                return false
            }

            if !filters.selectedActivityIds.isEmpty &&
                !filters.selectedActivityIds.contains(event.activity.id) {
                return false
            }

            if !filters.selectedTeacherIds.isEmpty {

                let teacherIds = Set(event.teachers.map(\.id))

                if filters.selectedTeacherIds.isDisjoint(with: teacherIds) {
                    return false
                }
            }

            if !filters.selectedDays.isEmpty {

                if Set(event.weeklyReccurance.days)
                    .isDisjoint(with: filters.selectedDays) {
                    return false
                }
            }

            return true
        }
    }

    // MARK: - Faceted filtering helper

    private func eventsFiltered(excluding filter: ScheduleFilterType) -> [EventModel] {

        allEvents.filter { event in

            if filter != .location {
                if !filters.selectedLocationIds.isEmpty &&
                    !filters.selectedLocationIds.contains(event.location.id) {
                    return false
                }
            }

            if filter != .activity {
                if !filters.selectedActivityIds.isEmpty &&
                    !filters.selectedActivityIds.contains(event.activity.id) {
                    return false
                }
            }

            if filter != .teacher {
                if !filters.selectedTeacherIds.isEmpty {

                    let teacherIds = Set(event.teachers.map(\.id))

                    if filters.selectedTeacherIds.isDisjoint(with: teacherIds) {
                        return false
                    }
                }
            }

            if filter != .day {
                if !filters.selectedDays.isEmpty {

                    if Set(event.weeklyReccurance.days)
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
        _ items: [EventModel],
        key: (EventModel) -> T
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
