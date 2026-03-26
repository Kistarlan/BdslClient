//
//  AvatarDTO.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 03.02.2026.
//

public struct AvatarDTO: Codable {
    public let id: String
    public let small: String
    public let medium: String
    public let large: String

    // MARK: - CodingKeys

    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case small
        case medium
        case large
    }

    // MARK: - Manual initializer

    public init(
        _id: String,
        small: String,
        medium: String,
        large: String
    ) {
        id = _id
        self.small = small
        self.medium = medium
        self.large = large
    }

    // MARK: - Codable

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        small = try container.decode(String.self, forKey: .small)
        medium = try container.decode(String.self, forKey: .medium)
        large = try container.decode(String.self, forKey: .large)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(small, forKey: .small)
        try container.encode(medium, forKey: .medium)
        try container.encode(large, forKey: .large)
    }
}

public extension AvatarDTO {
    func toDomain() -> Avatar {
        Avatar(
            id: id,
            small: small,
            medium: medium,
            large: large
        )
    }
}
