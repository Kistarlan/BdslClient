//
//  ActivityDTO.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 20.02.2026.
//

import Foundation

public struct ActivityDTO: Identifiable, Decodable {
    public let id: String
    public let colorHex: String
    public let title: String

    public enum CodingKeys: String, CodingKey {
        case id = "_id"
        case colorHex = "color"
        case title
    }
}

extension ActivityDTO {
    public func toDomain() -> Activity {
        Activity(id: id, colorHex: colorHex, title: title)
    }
}
