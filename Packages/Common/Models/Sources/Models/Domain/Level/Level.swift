//
//  Level.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 01.03.2026.
//

public struct Level: Identifiable, Hashable, Sendable {
    public let id: String
    public let colorHex: String
    public let title: String

    public init(id: String, colorHex: String, title: String) {
        self.id = id
        self.colorHex = colorHex
        self.title = title
    }
}
