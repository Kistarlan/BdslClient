//
//  AnyEncodable.swift
//  Models
//
//  Created by Oleh Rozkvas on 11.03.2026.
//

struct AnyEncodable: Encodable {

    private let encodeFunc: (Encoder) throws -> Void

    init(_ encodable: Encodable) {
        encodeFunc = encodable.encode
    }

    func encode(to encoder: Encoder) throws {
        try encodeFunc(encoder)
    }
}
