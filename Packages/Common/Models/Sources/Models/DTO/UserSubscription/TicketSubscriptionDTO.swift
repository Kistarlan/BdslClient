//
//  TicketSubscriptionDTO.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 23.02.2026.
//

import Foundation

public struct TicketSubscriptionDTO: Decodable {
    public let id: String
    public let paymentMethod: PaymentMethod?
    public let activities: [String]
    public let visits: [String]
    public let price: Double?
    public let comment: String?
    public let title: String
    public let userId: String
    public let recipient: String?
    public let startDate: Date
    public let endDate: Date

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case paymentMethod
        case activities
        case visits
        case price
        case comment
        case title
        case userId = "user"
        case recipient
        case startDate
        case endDate
        case createdBy
        case createdAt
        case updatedAt
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        paymentMethod = try container.decodeIfPresent(PaymentMethod.self, forKey: .paymentMethod)
        activities = try container.decodeIfPresent([String].self, forKey: .activities) ?? []
        visits = try container.decodeIfPresent([String].self, forKey: .visits) ?? []
        price = try container.decodeIfPresent(Double.self, forKey: .price)
        comment = try container.decodeIfPresent(String.self, forKey: .comment)
        title = try container.decode(String.self, forKey: .title)
        userId = try container.decode(String.self, forKey: .userId)
        recipient = try container.decodeIfPresent(String.self, forKey: .recipient)

        startDate = try TicketSubscriptionDTO.parseDate(container, forKey: .startDate)
        endDate = try Self.parseDate(container, forKey: .endDate)
    }

    private static func parseDate(_ container: KeyedDecodingContainer<CodingKeys>, forKey key: CodingKeys) throws -> Date {
        if let stringValue = try? container.decode(String.self, forKey: key) {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let date = formatter.date(from: stringValue) {
                return date
            }
            if let timestamp = Double(stringValue) {
                return Date(timeIntervalSince1970: timestamp)
            }
        }

        if let timestamp = try? container.decode(Double.self, forKey: key) {
            return Date(timeIntervalSince1970: timestamp)
        }

        throw DecodingError.dataCorruptedError(forKey: key, in: container, debugDescription: "Invalid date format for key \(key.stringValue)")
    }
}
