//
//  GroupDTO.swift
//  Models
//
//  Created by Oleh Rozkvas on 19.03.2026.
//

import Foundation

public struct GroupDTO: Identifiable, Decodable {
    public let id: String
    public let teachers: [GroupTeacherDTO]
    public let type: EventType
    public let start: Date
    public let end: Date
    public let recurrence: WeeklyRecurrenceDTO
    public let location: LocationDTO
    public let level: LevelDTO
    public let title: String
    public let activity: ActivityDTO
    public let duration: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case teachers
        case type
        case start
        case end
        case recurrence
        case location
        case level
        case title
        case activity
        case duration
    }
}

public extension GroupDTO {
    func toDomain() -> GroupModel {
        GroupModel(
            id: id,
            teachers: teachers.map { $0.toDomain() },
            type: type,
            startDate: start,
            endDate: end,
            recurrence: recurrence.toDomain(),
            location: location.toDomain(),
            level: level.toDomain(),
            title: title,
            activity: activity.toDomain(),
            duration: duration
        )
    }
}
