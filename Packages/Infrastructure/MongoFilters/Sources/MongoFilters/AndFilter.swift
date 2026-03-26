//
//  AndFilter.swift
//  Models
//
//  Created by Oleh Rozkvas on 11.03.2026.
//

struct AndFilter: MongoFilter {
    let filters: [MongoFilter]

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKey.self)

        try container.encode(
            filters.map { AnyEncodable($0) },
            forKey: DynamicCodingKey("$and")
        )
    }
}
