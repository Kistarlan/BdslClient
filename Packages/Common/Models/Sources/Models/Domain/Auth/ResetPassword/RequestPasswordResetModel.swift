//
//  RequestPasswordResetModel.swift
//  Models
//
//  Created by Oleh Rozkvas on 13.04.2026.
//

public struct RequestPasswordResetModel : Codable, Sendable {
    public let phone: String

    public init(_ phone: String) {
        self.phone = phone
    }
}
