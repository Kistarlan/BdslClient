//
//  UserDTO.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 23.01.2026.
//
import Foundation

public struct UserDTO: Codable {
    public let id: String
    public let name: String
    public let surname: String?
    public let fullName: String
    public let role: String
    public let contacts: ContactDTO
    public let avatar: AvatarDTO?

    // MARK: - CodingKeys
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case surname
        case fullName
        case role
        case contacts
        case avatar
    }

    // MARK: - Manual initializer
    public init(
        id: String,
        name: String,
        surname: String?,
        fullName: String,
        role: String,
        contacts: ContactDTO,
        avatar: AvatarDTO?
    ) {
        self.id = id
        self.name = name
        self.surname = surname
        self.fullName = fullName
        self.role = role
        self.contacts = contacts
        self.avatar = avatar
    }

    // MARK: - Codable
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.surname = try container.decodeIfPresent(String.self, forKey: .surname)
        self.fullName = try container.decode(String.self, forKey: .fullName)
        self.role = try container.decode(String.self, forKey: .role)
        self.contacts = try container.decode(ContactDTO.self, forKey: .contacts)
        self.avatar = try container.decodeIfPresent(AvatarDTO.self, forKey: .avatar)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(surname, forKey: .surname)
        try container.encode(fullName, forKey: .fullName)
        try container.encode(role, forKey: .role)
        try container.encode(contacts, forKey: .contacts)
        try container.encodeIfPresent(avatar, forKey: .avatar)
    }
}

extension UserDTO {
    public func toDomain() -> User {
        User(
            id: id,
            fullName: fullName,
            role: UserRole(rawValue: role) ?? .student,
            name: name,
            surname: surname,
            contacts: contacts.toDomain(),
            avatar: avatar == nil ? nil : avatar.map { $0.toDomain() }
        )
    }
}
