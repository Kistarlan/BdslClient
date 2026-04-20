//
//  SettingDTO.swift
//  Models
//
//  Created by Oleh Rozkvas on 20.04.2026.
//

public struct SettingDTO: Codable, Sendable {
    public let id: String
    public let name: String
    public let value: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case value
    }
}
