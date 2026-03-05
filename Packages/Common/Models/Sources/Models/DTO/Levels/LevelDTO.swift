//
//  LevelDTO.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 20.02.2026.
//

public struct LevelDTO: Identifiable, Decodable {
    public let id: String
    public let colorHex: String
    public let title: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case colorHex = "color"
        case title
    }
}

extension LevelDTO {
    public func toDomain() -> Level {
        Level(id: id, colorHex: colorHex, title: title)
    }
}
