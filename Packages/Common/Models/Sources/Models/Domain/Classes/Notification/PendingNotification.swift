//
//  PendingNotification.swift
//  Models
//
//  Created by Oleh Rozkvas on 27.03.2026.
//

import Foundation

public struct PendingNotification: Hashable, Sendable {
    public let id: String
    public let classId: String
    public let title: String
    public let body: String
    public let classDate: Date

    public init(id: String, classId: String, title: String, body: String, classDate: Date) {
        self.id = id
        self.classId = classId
        self.title = title
        self.body = body
        self.classDate = classDate
    }
}
