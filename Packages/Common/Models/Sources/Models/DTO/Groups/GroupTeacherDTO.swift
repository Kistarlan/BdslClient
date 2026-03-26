//
//  GroupTeacherDTO.swift
//  Models
//
//  Created by Oleh Rozkvas on 19.03.2026.
//

public struct GroupTeacherDTO: Identifiable, Decodable {
    public let id: String
    public let user: GroupUserDTO
    public let fullName: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case user
        case fullName
    }
}

public extension GroupTeacherDTO {
    func toDomain() -> GroupTeacher {
        GroupTeacher(
            id: id,
            name: user.name,
            surname: user.fullName,
            fullName: user.fullName
        )
    }
}
