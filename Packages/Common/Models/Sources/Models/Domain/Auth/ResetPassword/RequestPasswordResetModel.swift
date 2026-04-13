//
//  RequestPasswordResetModel.swift
//  Models
//
//  Created by Oleh Rozkvas on 13.04.2026.
//

public struct RequestPasswordResetModel : Codable, Sendable {
    public let channel: String
    public let phone: String

    public init(_ phone: String, _ channel: ResetPasswordChannel) {
        self.phone = phone
        self.channel = channel.rawValue
    }
}
