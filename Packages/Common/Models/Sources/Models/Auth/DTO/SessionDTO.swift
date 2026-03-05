//
//  SessionDTO.swift
//  Models
//
//  Created by Oleh Rozkvas on 11.03.2026.
//

public struct SessionDTO: Decodable, Sendable {
    public let authToken: String
    public let refreshToken: String
    public let user: UserIdentifierDTO

    enum CodingKeys: String, CodingKey {
        case authToken
        case refreshToken
        case user
    }
}
