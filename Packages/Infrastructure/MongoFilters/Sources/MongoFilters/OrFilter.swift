//
//  OrFilter.swift
//  Models
//
//  Created by Oleh Rozkvas on 11.03.2026.
//

struct OrFilter: MongoFilter {

    let filters: [MongoFilter]

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StaticCodingKeys.self)

        try container.encode(filters.map(AnyEncodable.init), forKey: .or)
    }

    enum StaticCodingKeys: String, CodingKey {
        case or = "$or"
    }
}
