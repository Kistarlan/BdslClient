//
//  UserIdentifier.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 04.02.2026.
//

public struct UserIdentifier: Equatable, Sendable {
    public let id: String
    public let fullName: String
    public let role: UserRole
}
