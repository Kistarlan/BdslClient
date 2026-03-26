//
//  LocationDTO.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 20.02.2026.
//

public struct LocationDTO: Identifiable, Decodable {
    public let id: String
    public let colorHex: String
    public let color2Hex: String
    public let title: String
    public let address: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case colorHex = "color"
        case color2Hex = "color2"
        case title
        case address
    }
}

public extension LocationDTO {
    func toDomain() -> Location {
        Location(
            id: id,
            title: title,
            address: address,
            colorHex: colorHex,
            color2Hex: color2Hex
        )
    }
}
