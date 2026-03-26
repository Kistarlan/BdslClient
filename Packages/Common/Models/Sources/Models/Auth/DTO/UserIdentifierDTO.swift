//
//  UserIdentifierDTO.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 04.02.2026.
//

public struct UserIdentifierDTO: Codable, Sendable {
    public let id: String
    public let fullName: String
    public let role: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case fullName
        case role
    }
}

public extension UserIdentifierDTO {
    func toDomain() -> UserIdentifier {
        UserIdentifier(
            id: id,
            fullName: fullName,
            role: UserRole(rawValue: role) ?? .student
        )
    }
}
