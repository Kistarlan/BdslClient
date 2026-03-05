//
//  EditUserInfoViewModel.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 12.02.2026.
//

import OSLog
import SwiftUI
import Models
import Services

@Observable
final class EditUserInfoViewModel {
    // MARK: - Editable fields

    var user: User
    var name: String
    var surname: String
    var phone: String
    var email: String
    var avatarData: Data?
    var avatar: Avatar?

    // MARK: - UI State
    var touchedFields: Set<EditUserInfoField> = []

    var isLoading = false
    var errorMessage: String = ""
    var isSaveEnabled: Bool {
        isFormValid &&
            !name.isEmpty &&
            !surname.isEmpty &&
            isValidEmail(email)
    }

    var showPhotoPicker = false
    var showCamera = false
    var showSourceDialog = false

    // MARK: - Dependencies

    private let usersService: UsersService
    private let imageService: ImageService
    private let appState: AppState
    let logger = Logger.forCategory("EditUserInfoViewModel")

    // MARK: - Init

    init(
        user: User,
        appState: AppState,
        usersService: UsersService,
        imageService: ImageService
    ) {
        self.user = user
        name = user.name
        surname = user.surname ?? ""
        phone = Self.getPhoneWithoutPrefix(user.contacts.phone)
        email = user.contacts.email ?? ""
        avatar = user.avatar

        self.usersService = usersService
        self.imageService = imageService
        self.appState = appState

        fillImageIfAvailable()
    }

    private static func getPhoneWithoutPrefix(_ phone: String?) -> String {
        guard let phone else { return "" }

        return phone.hasPrefix("+38") ? String(phone.dropFirst(3)) : phone
    }

    private func fillImageIfAvailable() {
        if let avatarInfo = avatar {
            Task {
                do {
                    avatarData = try await imageService.fetchImage(avatarInfo.medium)
                } catch {
                    logger.warning("Can't load image for \(avatarInfo.medium)")
                }
            }
        }
    }

    // MARK: - Actions

    func save() async -> Bool {
        touchedFields = [.name, .phone, .email]

        guard isSaveEnabled else { return false }

        isLoading = true
        defer { isLoading = false }

        do {
            let updatedUser = try await uploadUserInfo()
            user = updatedUser
            self.appState.updateUser(newUser: user)
            errorMessage = ""

            return true
        } catch {
            errorMessage = error.localizedDescription

            return false
        }
    }

    private func uploadUserInfo() async throws -> User {
        let data = User(
            id: user.id,
            fullName: "\(name) \(surname)",
            role: user.role,
            name: name,
            surname: surname,
            contacts: Contact(
                id: user.contacts.id,
                phone: normalizeUA(phone),
                telegram: user.contacts.telegram,
                email: email
            ),
            avatar: avatar
        )

        return try await usersService.updateUserInfo(data)
    }

    func setAvatar(_ data: Data) async {
        do {
            let updatedAvatar = try await imageService.uploadImage(data)

            avatarData = try await imageService.fetchImage(updatedAvatar.medium)

            avatar = updatedAvatar
        } catch {
            logger.warning("Can't update avatar")
        }
    }

    func fieldDidLoseFocus(_ field: EditUserInfoField) {
        touchedFields.insert(field)
    }

    // MARK: - Validation

    var nameError: LocalizedStringResource? {
        guard touchedFields.contains(.name) else { return nil }
        return name.isEmpty ? .nameIsRequired : nil
    }

    var surnameError: LocalizedStringResource? {
        guard touchedFields.contains(.surname) else { return nil }
        return surname.isEmpty ? .surnameIsRequired : nil
    }

    var emailError: LocalizedStringResource? {
        guard touchedFields.contains(.email) else { return nil }
        if email.isEmpty { return .emailIsRequired }
        if !isValidEmail(email) { return .invalidEmailFormat }
        return nil
    }

    var phoneError: LocalizedStringResource? {
        guard touchedFields.contains(.phone) else { return nil }
        if phone.isEmpty { return .phoneIsRequired }
        if !phone.isValidPhone { return .invalidPhoneFormat }
        return nil
    }

    var isFormValid: Bool {
        nameError == nil &&
            surnameError == nil &&
            emailError == nil &&
            phoneError == nil
    }

    func isValidEmail(_ email: String) -> Bool {
        let predicate = NSPredicate(
            format: "SELF MATCHES[c] %@",
            #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
        )
        return predicate.evaluate(with: email)
    }

    func normalizeUA(_ phone: String) -> String? {
        if phone.hasPrefix("+380") {
            return phone
        }

        if phone.hasPrefix("0") {
            return "+38" + phone
        }

        return nil
    }
}
