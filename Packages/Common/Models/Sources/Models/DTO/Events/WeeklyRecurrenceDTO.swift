//
//  WeeklyRecurrenceDTO.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 20.02.2026.
//

import Foundation

public struct WeeklyRecurrenceDTO: Identifiable, Decodable {
    public let id: String
    public let interval: Int
    public let untilDate: Date
    public let days: [DayRecurrenceType]

    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case interval
        case untilDate = "until"
        case days = "byday"
    }
}

public extension WeeklyRecurrenceDTO {
    func toDomain() -> WeeklyRecurrence {
        WeeklyRecurrence(
            id: id,
            interval: interval,
            untilDate: untilDate,
            days: days
        )
    }
}
