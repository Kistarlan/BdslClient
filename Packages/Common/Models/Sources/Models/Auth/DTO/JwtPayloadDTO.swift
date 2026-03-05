//
//  JwtPayloadDTO.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 26.01.2026.
//
import Foundation

public struct JwtPayloadDTO: Codable, Sendable {
    public let user: UserIdentifierDTO
    public let exp: TimeInterval

    private enum CodsKeys: String, CodingKey {
        case user
        case exp
    }
}
