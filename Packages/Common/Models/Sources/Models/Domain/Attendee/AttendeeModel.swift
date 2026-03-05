//
//  AttendeeModel.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 21.02.2026.
//

import Foundation

public struct AttendeeModel: Identifiable, Sendable {
    public let id: String
    public let status: AttendeeStatus
    public let event: EventModel
    public let enrollTime: Date

    // MARK: - Public initializer
    public init(
        id: String,
        status: AttendeeStatus,
        event: EventModel,
        enrollTime: Date
    ) {
        self.id = id
        self.status = status
        self.event = event
        self.enrollTime = enrollTime
    }
}
