//
//  NinFilter.swift
//  Models
//
//  Created by Oleh Rozkvas on 11.03.2026.
//

struct NinFilter<Value: Encodable>: MongoFilter {
    let field: String
    let values: [Value]

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKey.self)
        try container.encode(
            ["$nin": values],
            forKey: DynamicCodingKey(field)
        )
    }
}
