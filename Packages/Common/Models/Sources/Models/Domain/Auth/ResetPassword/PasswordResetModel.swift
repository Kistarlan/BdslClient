//
//  PasswordResetModel.swift
//  Models
//
//  Created by Oleh Rozkvas on 13.04.2026.
//

public struct PasswordResetModel: Encodable {
    public let inviteKey: String
    public let pin: Int
    public let newPassword: String

    public init(inviteKey: String, pin: Int, newPassword: String) {
        self.inviteKey = inviteKey
        self.pin = pin
        self.newPassword = newPassword
    }

    enum CodingKeys: String, CodingKey {
        case inviteKey = "invite"
        case pin
        case newPassword
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(inviteKey, forKey: .inviteKey)
        try container.encode(pin, forKey: .pin)
        try container.encode(newPassword, forKey: .newPassword)
    }
}
