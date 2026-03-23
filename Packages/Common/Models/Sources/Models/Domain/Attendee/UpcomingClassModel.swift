//
//  UpcomingClassModel.swift
//  Models
//
//  Created by Oleh Rozkvas on 21.03.2026.
//

import Foundation

public struct UpcomingClassModel: Hashable, Identifiable, Sendable {
    public let id: String
    public let event: EventModel
    public let concreateTime: Date

    public init(
        id: String,
        event: EventModel,
        concreateTime: Date
    ) {
        self.id = id
        self.event = event
        self.concreateTime = concreateTime
    }
}
