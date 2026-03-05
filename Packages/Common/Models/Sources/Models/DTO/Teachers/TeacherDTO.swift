//
//  TeacherDTO.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 20.02.2026.
//

public struct TeacherDTO: Identifiable, Decodable {
    public let id: String
    public let active: Bool
    public let activityIds: [String]
    public let userId: String
    public let about: String?

    enum CodingKeys: String, CodingKey {
        case id
        case active
        case activityIds = "activities"
        case userId = "user"
        case about
    }
}
