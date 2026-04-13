//
//  ResetPasswordInviteKey.swift
//  Models
//
//  Created by Oleh Rozkvas on 13.04.2026.
//

public struct ResetPasswordInviteKey : Decodable, Sendable {
    public let channel: String
    public let inviteKey: String

    enum CodingKeys: String, CodingKey {
        case channel
        case inviteKey = "key"
    }
}
