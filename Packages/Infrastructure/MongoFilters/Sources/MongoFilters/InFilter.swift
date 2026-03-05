import Foundation
//
//  InFilte.swift
//  Models
//
//  Created by Oleh Rozkvas on 11.03.2026.
//

/// A CodingKey that can be created from arbitrary strings at runtime.

struct InFilter<Value: Encodable>: MongoFilter {

    let field: String
    let values: [Value]

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKey.self)

        try container.encode(
            ["$in": values],
            forKey: DynamicCodingKey(stringValue: field)!
        )
    }
}

