//
//  ScheduleViewModelTests.swift
//  BdslClientTests
//

import Testing
import Models
@testable import BdslClient

@MainActor
struct ScheduleViewModelTests {
    private func makeViewModel(
        groups: [GroupModel] = [],
        groupsService: MockGroupsService? = nil
    ) -> (ScheduleViewModel, MockGroupsService) {
        let service = groupsService ?? MockGroupsService()
        service.fetchGroupsResult = .success(groups)
        let vm = ScheduleViewModel(
            appState: AppStateFactory.make(networkAvailable: true),
            groupsService: service
        )
        return (vm, service)
    }

    // MARK: - resetFilters

    @Test("resetFilters clears all active filters")
    func resetFilters_clearsAll() {
        let (vm, _) = makeViewModel()
        vm.filters.selectedLocationIds = ["loc-1"]
        vm.filters.selectedActivityIds = ["act-1"]
        vm.filters.selectedDays = [.monday]

        vm.resetFilters()

        #expect(vm.filters.isEmpty)
    }

    // MARK: - toggle

    @Test("toggle expands the given filter")
    func toggle_expandsFilter() {
        let (vm, _) = makeViewModel()
        vm.expandedFilter = nil

        vm.toggle(.location)

        #expect(vm.expandedFilter == .location)
    }

    @Test("toggle collapses the same filter when already expanded")
    func toggle_collapsesSameFilter() {
        let (vm, _) = makeViewModel()
        vm.toggle(.location)
        #expect(vm.expandedFilter == .location)

        vm.toggle(.location)

        #expect(vm.expandedFilter == nil)
    }

    @Test("toggle switches to a different filter")
    func toggle_switchesToDifferentFilter() {
        let (vm, _) = makeViewModel()
        vm.toggle(.location)

        vm.toggle(.activity)

        #expect(vm.expandedFilter == .activity)
    }

    // MARK: - loadEvents & groupSections

    @Test("loadEvents populates groupSections from service")
    func loadEvents_populatesGroupSections() async {
        let group = GroupModelFactory.makeGroup(days: [.monday])
        let (vm, service) = makeViewModel()
        service.fetchGroupsResult = .success([group])

        await vm.loadEvents(forceReload: false)

        #expect(!vm.groupSections.isEmpty)
    }

    @Test("groupSections is empty when no groups loaded")
    func groupSections_emptyWithNoGroups() {
        let (vm, _) = makeViewModel(groups: [])
        #expect(vm.groupSections.isEmpty)
    }

    // MARK: - Location filter

    @Test("Location filter excludes groups from other locations")
    func locationFilter_excludesOtherLocations() async {
        let group1 = GroupModelFactory.makeGroup(id: "g1", locationId: "loc-A")
        let group2 = GroupModelFactory.makeGroup(id: "g2", locationId: "loc-B")
        let (vm, service) = makeViewModel()
        service.fetchGroupsResult = .success([group1, group2])
        await vm.loadEvents(forceReload: false)

        vm.filters.selectedLocationIds = ["loc-A"]

        let sections = vm.groupSections
        let allGroupIds = sections.flatMap(\.groups).map(\.id)
        #expect(allGroupIds.contains("g1"))
        #expect(!allGroupIds.contains("g2"))
    }

    // MARK: - Activity filter

    @Test("Activity filter excludes groups with other activities")
    func activityFilter_excludesOtherActivities() async {
        let group1 = GroupModelFactory.makeGroup(id: "g1", activityId: "yoga")
        let group2 = GroupModelFactory.makeGroup(id: "g2", activityId: "dance")
        let (vm, service) = makeViewModel()
        service.fetchGroupsResult = .success([group1, group2])
        await vm.loadEvents(forceReload: false)

        vm.filters.selectedActivityIds = ["yoga"]

        let allGroupIds = vm.groupSections.flatMap(\.groups).map(\.id)
        #expect(allGroupIds.contains("g1"))
        #expect(!allGroupIds.contains("g2"))
    }

    // MARK: - Day filter

    @Test("Day filter includes only groups scheduled on selected days")
    func dayFilter_includesOnlyMatchingDays() async {
        let mondayGroup = GroupModelFactory.makeGroup(id: "g1", days: [.monday])
        let fridayGroup = GroupModelFactory.makeGroup(id: "g2", days: [.friday])
        let (vm, service) = makeViewModel()
        service.fetchGroupsResult = .success([mondayGroup, fridayGroup])
        await vm.loadEvents(forceReload: false)

        vm.filters.selectedDays = [.monday]

        let allGroupIds = vm.groupSections.flatMap(\.groups).map(\.id)
        #expect(allGroupIds.contains("g1"))
        #expect(!allGroupIds.contains("g2"))
    }

    // MARK: - Available filter options (faceted)

    @Test("availableLocations contains all unique locations")
    func availableLocations_containsUniqueLocations() async {
        let group1 = GroupModelFactory.makeGroup(id: "g1", locationId: "loc-A")
        let group2 = GroupModelFactory.makeGroup(id: "g2", locationId: "loc-B")
        let group3 = GroupModelFactory.makeGroup(id: "g3", locationId: "loc-A") // duplicate
        let (vm, service) = makeViewModel()
        service.fetchGroupsResult = .success([group1, group2, group3])
        await vm.loadEvents(forceReload: false)

        let locationIds = Set(vm.availableLocations.map(\.id))
        #expect(locationIds == ["loc-A", "loc-B"])
    }

    @Test("availableDays contains all unique days across groups")
    func availableDays_containsUniqueDays() async {
        let group1 = GroupModelFactory.makeGroup(id: "g1", days: [.monday, .wednesday])
        let group2 = GroupModelFactory.makeGroup(id: "g2", days: [.friday])
        let (vm, service) = makeViewModel()
        service.fetchGroupsResult = .success([group1, group2])
        await vm.loadEvents(forceReload: false)

        let days = Set(vm.availableDays)
        #expect(days.contains(.monday))
        #expect(days.contains(.wednesday))
        #expect(days.contains(.friday))
    }

    // MARK: - isInitialized

    @Test("isInitialized becomes true after successful load")
    func isInitialized_trueAfterLoad() async {
        let (vm, _) = makeViewModel(groups: [])

        await vm.loadEvents(forceReload: false)

        #expect(vm.isInitialized)
        #expect(!vm.isLoading)
    }

    @Test("loadEvents still marks isInitialized on service failure (set in defer)")
    func loadEvents_setsIsInitializedOnFailure() async {
        let (vm, service) = makeViewModel()
        service.fetchGroupsResult = .failure(MockError.generic)

        await vm.loadEvents(forceReload: false)

        // isInitialized is set inside `defer`, so it's always true after loadEvents finishes.
        #expect(vm.isInitialized)
        // groupSections remain empty since no data was loaded.
        #expect(vm.groupSections.isEmpty)
    }
}
