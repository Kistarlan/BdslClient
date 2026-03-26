//
//  MongoFilter.swift
//  Models
//
//  Created by Oleh Rozkvas on 11.03.2026.
//

import Foundation

public protocol MongoFilter: Encodable {}

public extension MongoFilter {
    func makeFilterQuery() throws -> String {
        let data = try JSONEncoder().encode(AnyEncodable(self))

        guard let string = String(data: data, encoding: .utf8) else {
            throw URLError(.badURL)
        }

        return string
    }
}
