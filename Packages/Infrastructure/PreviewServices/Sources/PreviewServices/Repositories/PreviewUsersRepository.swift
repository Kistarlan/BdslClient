//
//  PreviewUsersRepository.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 25.02.2026.
//

import Models
import Services

final class PreviewUsersRepository: UsersRepository {
    let previewDataProvider: PreviewDataProvider

    init(previewDataProvider: PreviewDataProvider) {
        self.previewDataProvider = previewDataProvider
    }

    func fetchUserInfo(for id: String) async throws -> UserDTO {
        let users = try previewDataProvider.load([UserDTO].self, from: "Users")

        guard let dto = users.first(where: { $0.id == id }) else {
            throw PreviewUsersRepositoryError.userNotFound(id)
        }

        return dto
    }

    func fetchUsersInfo(for ids: [String]) async throws -> [UserDTO] {
        let users = try previewDataProvider.load([UserDTO].self, from: "Users")

        return users.filter {
            ids.contains($0.id)
        }
    }

    func updateUserInfo(_ user: User) async throws -> UserDTO {
        return UserDTO(
            id: user.id,
            name: user.name,
            surname: user.surname,
            fullName: user.fullName,
            role: UserRole.student.rawValue,
            contacts: ContactDTO(
                _id: user.contacts.id,
                phone: user.contacts.phone,
                telegram: user.contacts.telegram,
                email: user.contacts.email
            ),
            avatar: user.avatar == nil ? nil : AvatarDTO(
                _id: user.avatar!.id,
                small: user.avatar!.small,
                medium: user.avatar!.medium,
                large: user.avatar!.large
            )
        )
    }
}

private enum PreviewUsersRepositoryError: Error {
    case userNotFound(String)
}
