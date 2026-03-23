//
//  AttendeeModel.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 21.02.2026.
//

import Foundation

public struct AttendeeModel: Identifiable, Sendable {
    public let id: String
    public let event: EventModel
    public let enrollTime: Date

    public init(
        id: String,
        event: EventModel,
        enrollTime: Date
    ) {
        self.id = id
        self.event = event
        self.enrollTime = enrollTime
    }
}
