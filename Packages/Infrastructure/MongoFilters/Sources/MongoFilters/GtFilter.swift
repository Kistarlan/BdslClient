//
//  GtFilter.swift
//  Models
//
//  Created by Oleh Rozkvas on 11.03.2026.
//

struct GtFilter<Value: Encodable>: MongoFilter {
    let field: String
    let value: Value

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKey.self)

        try container.encode(
            ["$gt": value],
            forKey: DynamicCodingKey(field)
        )
    }
}
