//
//  Avatar.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 03.02.2026.
//

public struct Avatar: Equatable, Hashable, Sendable {
    public let id: String
    public let small: String
    public let medium: String
    public let large: String

    public init(id: String, small: String, medium: String, large: String) {
        self.id = id
        self.small = small
        self.medium = medium
        self.large = large
    }
}
