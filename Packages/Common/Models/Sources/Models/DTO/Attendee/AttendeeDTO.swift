//
//  AttendeeDTO.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 20.02.2026.
//

import Foundation

public struct AttendeeDTO: Identifiable, Decodable {
    public let id: String
    public let status: AttendeeStatus
    public let eventId: String
    public let userId: String
    public let enroll: EnrollDTO?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case status
        case eventId = "event"
        case userId = "user"
        case enroll
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        do {
            self.id = try container.decode(String.self, forKey: .id)
            self.status = try container.decode(AttendeeStatus.self, forKey: .status)
            self.eventId = try container.decode(String.self, forKey: .eventId)
            self.userId = try container.decode(String.self, forKey: .userId)
            self.enroll = try container.decodeIfPresent(EnrollDTO.self, forKey: .enroll)
        } catch {
            print(error)

            throw error
        }
    }
}
