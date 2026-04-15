//
//  ChangePasswordRequest.swift
//  Models
//
//  Created by Oleh Rozkvas on 15.04.2026.
//

public struct ChangePasswordRequest: Encodable {
    public let userId: String
    public let oldPassword: String
    public let newPassword: String

    public init(userId: String, oldPassword: String, newPassword: String) {
        self.userId = userId
        self.oldPassword = oldPassword
        self.newPassword = newPassword
    }

    enum CodingKeys: String, CodingKey {
        case userId = "user"
        case oldPassword
        case newPassword
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(userId, forKey: .userId)
        try container.encode(oldPassword, forKey: .oldPassword)
        try container.encode(newPassword, forKey: .newPassword)
    }
}
