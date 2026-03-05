//
//  EventType.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 20.02.2026.
//

public enum EventType: String, Codable, Sendable {
    case group = "Group"
    case masterClass = "Class"
    case rent = "Rent"
}
