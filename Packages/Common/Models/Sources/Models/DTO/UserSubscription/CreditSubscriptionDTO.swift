//
//  CreditSubscriptionDTO.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 20.02.2026.
//

import Foundation

public struct CreditSubscriptionDTO: Decodable {
    public let id: String
    public let activityIds: [String]
    public let visitsIds: [String]
    public let userId: String
    public let title: String
    public let startDate: Date
    public let closed: Bool

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case closed
        case activityIds = "activities"
        case visitsIds = "visits"
        case userId = "user"
        case title
        case startDate
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        activityIds = try container.decode([String].self, forKey: .activityIds)
        visitsIds = try container.decodeIfPresent([String].self, forKey: .visitsIds) ?? []
        userId = try container.decode(String.self, forKey: .userId)
        title = try container.decode(String.self, forKey: .title)
        startDate = try container.decode(Date.self, forKey: .startDate)
        closed = try container.decode(Bool.self, forKey: .closed)
    }
}
