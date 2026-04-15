//
//  NotificationSettingsViewModelTests.swift
//  BdslClientTests
//

import Testing
import Models
@testable import BdslClient

@MainActor
struct NotificationSettingsViewModelTests {
    private func makeViewModel(
        leadTime: NotificationLeadTime = .disabled
    ) -> NotificationSettingsViewModel {
        NotificationSettingsViewModel(
            appState: AppStateFactory.make(notificationLeadTime: leadTime),
            permissionService: MockPermissionService()
        )
    }

    // MARK: - Initial state

    @Test("Initial selected matches AppState notificationLeadTime")
    func initialSelected_matchesAppState() {
        let vm = makeViewModel(leadTime: .preset(2))

        #expect(vm.selected == .preset(2))
        #expect(vm.initialValue == .preset(2))
    }

    @Test("isChanged is false when selection equals initial value")
    func isChanged_falseWhenUnchanged() {
        let vm = makeViewModel(leadTime: .preset(1))

        #expect(!vm.isChanged)
    }

    // MARK: - selectPreset

    @Test("selectPreset updates selected value")
    func selectPreset_updatesSelected() {
        let vm = makeViewModel()

        vm.selectPreset(.preset(4))

        #expect(vm.selected == .preset(4))
    }

    @Test("selectPreset hides custom selection panel")
    func selectPreset_hidesCustomSelection() {
        let vm = makeViewModel()
        vm.showCustomSelection = true

        vm.selectPreset(.preset(1))

        #expect(!vm.showCustomSelection)
    }

    @Test("isChanged is true after selecting a different preset")
    func isChanged_trueAfterPresetChange() {
        let vm = makeViewModel(leadTime: .disabled)

        vm.selectPreset(.preset(2))

        #expect(vm.isChanged)
    }

    // MARK: - selectCustom

    @Test("selectCustom sets selected to .custom with given hours")
    func selectCustom_setsCustomSelected() {
        let vm = makeViewModel()

        vm.selectCustom(6)

        if case let .custom(hours) = vm.selected {
            #expect(hours == 6)
        } else {
            Issue.record("Expected .custom selection")
        }
    }

    @Test("selectCustom shows custom selection panel")
    func selectCustom_showsCustomSelection() {
        let vm = makeViewModel()

        vm.selectCustom(3)

        #expect(vm.showCustomSelection)
    }

    @Test("isCustom is true when selected is .custom")
    func isCustom_trueForCustom() {
        let vm = makeViewModel()
        vm.selectCustom(5)

        #expect(vm.isCustom)
    }

    @Test("isCustom is false for preset selection")
    func isCustom_falseForPreset() {
        let vm = makeViewModel()
        vm.selectPreset(.preset(1))

        #expect(!vm.isCustom)
    }

    // MARK: - disable

    @Test("disable sets selected to .disabled")
    func disable_setsDisabled() {
        let vm = makeViewModel(leadTime: .preset(2))

        vm.disable()

        #expect(vm.selected == .disabled)
    }

    @Test("disable hides custom selection panel")
    func disable_hidesCustomSelection() {
        let vm = makeViewModel()
        vm.showCustomSelection = true

        vm.disable()

        #expect(!vm.showCustomSelection)
    }

    // MARK: - save

    @Test("save writes selected value to AppState")
    func save_updatesAppState() {
        let appState = AppStateFactory.make(notificationLeadTime: .disabled)
        let vm = NotificationSettingsViewModel(
            appState: appState,
            permissionService: MockPermissionService()
        )
        vm.selectPreset(.preset(8))

        vm.save()

        #expect(appState.notificationLeadTime == .preset(8))
    }

    @Test("save does not clear isChanged — initialValue is not updated by save()")
    func save_doesNotResetInitialValue() {
        let vm = makeViewModel(leadTime: .disabled)
        vm.selectPreset(.preset(4))
        #expect(vm.isChanged)

        vm.save()

        // save() only writes to AppState; it does not update initialValue,
        // so isChanged remains true until the screen is re-initialized.
        #expect(vm.isChanged)
    }

    // MARK: - requestNotificationPermission

    @Test("Denied permission sets showWarning to true")
    func deniedPermission_setsShowWarning() async {
        let permService = MockPermissionService()
        permService.notificationGranted = false
        let vm = NotificationSettingsViewModel(
            appState: AppStateFactory.make(),
            permissionService: permService
        )

        await vm.requestNotificationPermission()

        #expect(vm.showWarning)
    }

    @Test("Granted permission keeps showWarning false")
    func grantedPermission_keepsShowWarningFalse() async {
        let permService = MockPermissionService()
        permService.notificationGranted = true
        let vm = NotificationSettingsViewModel(
            appState: AppStateFactory.make(),
            permissionService: permService
        )

        await vm.requestNotificationPermission()

        #expect(!vm.showWarning)
    }
}
