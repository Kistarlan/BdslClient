//
//  AttendeeDTO.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 20.02.2026.
//

import Foundation

public struct AttendeeDTO: Identifiable, Decodable {
    public let id: String // contains info about 1.event 2. date of class 3. userId
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

        id = try container.decode(String.self, forKey: .id)
        status = try container.decode(AttendeeStatus.self, forKey: .status)
        eventId = try container.decode(String.self, forKey: .eventId)
        userId = try container.decode(String.self, forKey: .userId)
        enroll = try container.decodeIfPresent(EnrollDTO.self, forKey: .enroll)
    }
}

public extension AttendeeDTO {
    func parseAttendeeId() throws -> (eventId: String, eventTime: Date?, userId: String) {
        let parts = id.split(separator: ":")
        guard parts.count == 2 else { throw AttendeeDTOError.parseIdError(id: id) }

        let leftParts = parts[0].split(separator: ".")

        let eventId = String(leftParts[0])
        let eventTime = leftParts.count > 1 ? parseDate(String(leftParts[1])) : nil
        let userId = String(parts[1])

        return (eventId, eventTime, userId)
    }

    func parseDate(_ value: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.date(from: value)
    }
}
