//
//  AuthSSEResponseDTO.swift
//  Models
//
//  Created by Oleh Rozkvas on 06.03.2026.
//

public struct AuthSSEResponseDTO: Decodable, Sendable {
    public let session: SessionDTO?
    public let approved: Bool

    enum CodingKeys: String, CodingKey {
        case session
        case approved
    }
}
