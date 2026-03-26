//
//  ReccurenceDTO.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 20.02.2026.
//

import Foundation

public enum ReccurenceDTO: Identifiable, Decodable {
    case weekly(WeeklyRecurrenceDTO)

    public var id: String {
        switch self {
        case let .weekly(model): return model.id
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(EventRccurenceType.self, forKey: .type)

        switch type {
        case .weekly: self = try .weekly(WeeklyRecurrenceDTO(from: decoder))
        }
    }

    private enum CodingKeys: String, CodingKey {
        case type = "frequency"
    }
}
