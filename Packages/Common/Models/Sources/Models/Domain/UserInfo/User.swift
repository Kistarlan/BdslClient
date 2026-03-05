//
//  User.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 23.01.2026.
//

public struct User: Equatable, Hashable, Sendable {
    public let id: String
    public let fullName: String
    public let role: UserRole
    public let name: String
    public let surname: String?
    public let contacts: Contact
    public let avatar: Avatar?

    // 🔹 Public init
    public init(
        id: String,
        fullName: String,
        role: UserRole,
        name: String,
        surname: String?,
        contacts: Contact,
        avatar: Avatar?
    ) {
        self.id = id
        self.fullName = fullName
        self.role = role
        self.name = name
        self.surname = surname
        self.contacts = contacts
        self.avatar = avatar
    }
}
