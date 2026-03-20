//
//  GroupUserDTO.swift
//  Models
//
//  Created by Oleh Rozkvas on 19.03.2026.
//

public struct GroupUserDTO: Identifiable, Decodable {
    public let id: String
    public let name: String
    public let surname: String
    public let fullName: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case surname
        case fullName
    }
}
