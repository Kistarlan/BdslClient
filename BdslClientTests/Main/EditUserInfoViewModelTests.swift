//
//  EditUserInfoViewModelTests.swift
//  BdslClientTests
//

import Testing
import Models
@testable import BdslClient

@MainActor
struct EditUserInfoViewModelTests {
    private func makeViewModel(
        name: String = "John",
        surname: String? = "Doe",
        phone: String? = "+380501234567",
        email: String? = "john@example.com"
    ) -> EditUserInfoViewModel {
        let user = User(
            id: "u1",
            fullName: "\(name) \(surname ?? "")",
            role: .student,
            name: name,
            surname: surname,
            contacts: Contact(id: "c1", phone: phone, email: email),
            avatar: nil
        )
        return EditUserInfoViewModel(
            user: user,
            appState: AppStateFactory.make(),
            usersService: MockUsersService(),
            imageService: MockImageService()
        )
    }

    // MARK: - Email validation

    @Test("Valid email format returns true")
    func validEmail_returnsTrue() {
        let vm = makeViewModel()
        #expect(vm.isValidEmail("user@example.com"))
        #expect(vm.isValidEmail("test.name+tag@sub.domain.org"))
    }

    @Test("Invalid email format returns false")
    func invalidEmail_returnsFalse() {
        let vm = makeViewModel()
        #expect(!vm.isValidEmail("notanemail"))
        #expect(!vm.isValidEmail("missing@domain"))
        #expect(!vm.isValidEmail("@no-user.com"))
        #expect(!vm.isValidEmail(""))
    }

    // MARK: - Phone normalization

    @Test("Phone starting with 0 gets +38 prefix")
    func normalizeUA_phoneWith0_addsPrefix() {
        let vm = makeViewModel()
        #expect(vm.normalizeUA("0501234567") == "+380501234567")
    }

    @Test("Phone already starting with +380 is returned unchanged")
    func normalizeUA_alreadyNormalized_unchanged() {
        let vm = makeViewModel()
        #expect(vm.normalizeUA("+380501234567") == "+380501234567")
    }

    @Test("Phone without known prefix returns nil")
    func normalizeUA_unknownFormat_returnsNil() {
        let vm = makeViewModel()
        #expect(vm.normalizeUA("501234567") == nil)
        #expect(vm.normalizeUA("+1234567890") == nil)
    }

    // MARK: - fieldDidLoseFocus

    @Test("fieldDidLoseFocus adds field to touchedFields")
    func fieldDidLoseFocus_addsToTouched() {
        let vm = makeViewModel()
        #expect(!vm.touchedFields.contains(.name))

        vm.fieldDidLoseFocus(.name)

        #expect(vm.touchedFields.contains(.name))
    }

    // MARK: - Field error visibility (only shown after touch)

    @Test("nameError is nil before field is touched")
    func nameError_nilBeforeTouch() {
        let vm = makeViewModel(name: "")
        #expect(vm.nameError == nil)
    }

    @Test("nameError is set after touching empty name field")
    func nameError_setAfterTouchWithEmptyName() {
        let vm = makeViewModel(name: "")
        vm.fieldDidLoseFocus(.name)
        vm.name = ""

        #expect(vm.nameError != nil)
    }

    @Test("nameError is nil when name is not empty after touch")
    func nameError_nilWhenNameFilled() {
        let vm = makeViewModel(name: "Alice")
        vm.fieldDidLoseFocus(.name)

        #expect(vm.nameError == nil)
    }

    @Test("emailError is nil before touching email field")
    func emailError_nilBeforeTouch() {
        let vm = makeViewModel(email: "bad")
        #expect(vm.emailError == nil)
    }

    @Test("emailError shows invalidEmailFormat after touching with bad email")
    func emailError_invalidAfterTouch() {
        let vm = makeViewModel(email: "bad-email")
        vm.fieldDidLoseFocus(.email)

        #expect(vm.emailError != nil)
    }

    @Test("emailError shows emailIsRequired for empty email after touch")
    func emailError_requiredAfterTouchEmpty() {
        let vm = makeViewModel(email: "")
        vm.fieldDidLoseFocus(.email)
        vm.email = ""

        #expect(vm.emailError != nil)
    }

    // MARK: - isFormValid

    @Test("isFormValid is true when all visible fields are valid after touch-all")
    func isFormValid_trueWithValidFields() {
        let vm = makeViewModel(
            name: "Alice",
            surname: "Smith",
            phone: "+380501234567",
            email: "alice@example.com"
        )
        vm.fieldDidLoseFocus(.name)
        vm.fieldDidLoseFocus(.surname)
        vm.fieldDidLoseFocus(.email)
        vm.fieldDidLoseFocus(.phone)
        vm.phone = "0501234567"
        vm.email = "alice@example.com"

        #expect(vm.isFormValid)
    }

    // MARK: - isSaveEnabled

    @Test("isSaveEnabled is false when name is empty")
    func isSaveEnabled_falseWithEmptyName() {
        let vm = makeViewModel()
        vm.name = ""

        #expect(!vm.isSaveEnabled)
    }

    @Test("isSaveEnabled is false with invalid email")
    func isSaveEnabled_falseWithInvalidEmail() {
        let vm = makeViewModel()
        vm.email = "not-valid"

        #expect(!vm.isSaveEnabled)
    }
}
