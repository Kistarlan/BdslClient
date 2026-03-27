//
//  ClassNotification.swift
//  Models
//
//  Created by Oleh Rozkvas on 26.03.2026.
//

import Foundation

public struct ClassNotification: Hashable, Sendable {
    public let id: String
    public let title: String
    public let body: String
    public let fireDate: Date
    public let classDate: Date

    public init(id: String, title: String, body: String, fireDate: Date, classDate: Date) {
        self.id = id
        self.title = title
        self.body = body
        self.fireDate = fireDate
        self.classDate = classDate
    }
}
