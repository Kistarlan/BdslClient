//
//  Contact.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 03.02.2026.
//

public struct Contact: Equatable, Hashable, Sendable {
    public let id: String
    public let phone: String?
    public let telegram: String?
    public let email: String?

    public init(
        id: String,
        phone: String? = nil,
        telegram: String? = nil,
        email: String? = nil
    ) {
        self.id = id
        self.phone = phone
        self.telegram = telegram
        self.email = email
    }
}
