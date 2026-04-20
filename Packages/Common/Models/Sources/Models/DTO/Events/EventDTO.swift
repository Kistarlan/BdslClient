//
//  EventDTO.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 20.02.2026.
//

import Foundation

public struct EventDTO: Identifiable, Decodable {
    public let id: String
    public let teacherIds: [String]?
    public let type: EventType
    public let recurrence: ReccurenceDTO?
    public let startDate: Date
    public let endDate: Date
    public let locationId: String
    public let levelId: String?
    public let title: String?
    public let activityId: String?
    public let subscription: EventSubscriptionDTO?

    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case teacherIds = "teachers"
        case type
        case recurrence
        case startDate = "start"
        case endDate = "end"
        case locationId = "location"
        case levelId = "level"
        case title
        case activityId = "activity"
        case subscription
    }
}
