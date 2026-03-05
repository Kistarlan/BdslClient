//
//  RegularSubscriptionDTO.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 20.02.2026.
//

import Foundation

public struct RegularSubscriptionDTO: Decodable {
    public let id: String
    public let activityIds: [String]
    public let visitsIds: [String]
    public let userId: String
    public let title: String
    public let startDate: Date

    public let unlimited: Bool
    public let endDate: Date
    public let visitsLimit: Int

    public let paymentMethod: PaymentMethod?
    public let price: Double?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case paymentMethod
        case activityIds = "activities"
        case visitsIds = "visits"
        case unlimited
        case startDate
        case endDate
        case userId = "user"
        case visitsLimit
        case title
        case price
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        activityIds = try container.decodeIfPresent([String].self, forKey: .activityIds) ?? []
        visitsIds = try container.decodeIfPresent([String].self, forKey: .visitsIds) ?? []
        userId = try container.decode(String.self, forKey: .userId)
        title = try container.decode(String.self, forKey: .title)
        startDate = try container.decode(Date.self, forKey: .startDate)
        unlimited = try container.decodeIfPresent(Bool.self, forKey: .unlimited) ?? false
        endDate = try RegularSubscriptionDTO.parseEndDate(from: container)
        visitsLimit = try container.decode(Int.self, forKey: .visitsLimit)
        paymentMethod = try container.decodeIfPresent(PaymentMethod.self, forKey: .paymentMethod)
        price = try container.decodeIfPresent(Double.self, forKey: .price)
    }

    private static func parseEndDate(from container: KeyedDecodingContainer<CodingKeys>) throws -> Date {
        if let stringValue = try? container.decode(String.self, forKey: .endDate) {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let date = formatter.date(from: stringValue) {
                return date
            }

            if let timestamp = Double(stringValue) {
                return Date(timeIntervalSince1970: timestamp)
            }
        }

        if let timestamp = try? container.decode(Double.self, forKey: .endDate) {
            return Date(timeIntervalSince1970: timestamp)
        }

        throw DecodingError.dataCorruptedError(forKey: .endDate, in: container, debugDescription: "Invalid endDate format")
    }
}
