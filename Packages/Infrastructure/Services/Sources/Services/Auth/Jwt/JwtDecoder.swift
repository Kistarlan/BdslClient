//
//  JwtDecoder.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 26.01.2026.
//

// protocol JwtDecoder {
//    func decode(_ token: String) throws -> JwtPayloadDTO
//    func encode(payload: JwtPayloadDTO) -> String
// }

public protocol JwtDecoder: Sendable {
    func decode<T: Decodable>(_ token: String, as type: T.Type) throws -> T
    func encode<T: Encodable>(_ payload: T) throws -> String
}
