//
//  UpdateUserDTO.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 12.02.2026.
//

public struct UpdateUserDTO: Codable {
    public let name: String
    public let surname: String
    public let role: String
    public let contacts: ContactDTO
    public let avatar: AvatarDTO?

    // MARK: - CodingKeys

    private enum CodingKeys: String, CodingKey {
        case name
        case surname
        case role
        case contacts
        case avatar
    }

    // MARK: - Manual initializer

    public init(
        name: String,
        surname: String,
        role: String,
        contacts: ContactDTO,
        avatar: AvatarDTO?
    ) {
        self.name = name
        self.surname = surname
        self.role = role
        self.contacts = contacts
        self.avatar = avatar
    }

    // MARK: - Codable

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = try container.decode(String.self, forKey: .name)
        surname = try container.decode(String.self, forKey: .surname)
        role = try container.decode(String.self, forKey: .role)
        contacts = try container.decode(ContactDTO.self, forKey: .contacts)
        avatar = try container.decodeIfPresent(AvatarDTO.self, forKey: .avatar)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(name, forKey: .name)
        try container.encode(surname, forKey: .surname)
        try container.encode(role, forKey: .role)
        try container.encode(contacts, forKey: .contacts)
        try container.encodeIfPresent(avatar, forKey: .avatar)
    }
}
