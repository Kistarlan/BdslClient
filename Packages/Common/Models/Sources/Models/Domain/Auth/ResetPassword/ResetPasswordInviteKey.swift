//
//  ResetPasswordInviteKey.swift
//  Models
//
//  Created by Oleh Rozkvas on 13.04.2026.
//

public struct ResetPasswordInviteKey: Decodable, Hashable, Sendable {
    public let channel: ResetPasswordChannel
    public let inviteKey: String

    public init(channel: ResetPasswordChannel = .telegramBot, inviteKey: String) {
        self.channel = channel
        self.inviteKey = inviteKey
    }

    enum CodingKeys: String, CodingKey {
        case channel
        case inviteKey = "key"
    }
}
