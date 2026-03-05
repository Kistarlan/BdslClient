//
//  LoginViaTelegramResponseDTO.swift
//  Services
//
//  Created by Oleh Rozkvas on 08.03.2026.
//

public struct LoginViaTelegramResponseDTO: Decodable {
    public let session: String

    enum CodingKeys: String, CodingKey {
        case session
    }
}
