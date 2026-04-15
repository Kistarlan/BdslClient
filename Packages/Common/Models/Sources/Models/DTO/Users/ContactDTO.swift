//
//  ContactDTO.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 03.02.2026.
//

public struct ContactDTO: Codable {
    public let _id: String
    public let phone: String?
    public let telegram: String?
    public let email: String?

    // MARK: - CodingKeys

    private enum CodingKeys: String, CodingKey {
        case _id
        case phone
        case telegram
        case email
    }

    // MARK: - Manual initializer

    public init(
        _id: String,
        phone: String?,
        telegram: String?,
        email: String?
    ) {
        self._id = _id
        self.phone = phone
        self.telegram = telegram
        self.email = email
    }

    // MARK: - Codable

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        _id = try container.decode(String.self, forKey: ._id)
        phone = try container.decodeIfPresent(String.self, forKey: .phone)
        telegram = try container.decodeIfPresent(String.self, forKey: .telegram)
        email = try container.decodeIfPresent(String.self, forKey: .email)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(_id, forKey: ._id)
        try container.encodeIfPresent(phone, forKey: .phone)
        try container.encodeIfPresent(telegram, forKey: .telegram)
        try container.encodeIfPresent(email, forKey: .email)
    }
}

public extension ContactDTO {
    func toDomain() -> Contact {
        Contact(
            id: _id, phone: phone, telegram: telegram, email: email
        )
    }
}

public extension ContactDTO : CustomStringConvertible {
    public var description: String {
        "ContactDTO(id: \(_id), phone: \(phone ?? "nil"), telegram: \(telegram ?? "nil"), email: \(email ?? "nil"))"
    }
}
