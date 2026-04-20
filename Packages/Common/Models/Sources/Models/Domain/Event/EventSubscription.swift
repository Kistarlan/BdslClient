//
//  EventSubscription.swift
//  Models
//
//  Created by Oleh Rozkvas on 20.04.2026.
//

public struct EventSubscription: Hashable, Sendable, Identifiable {
    public let id: String
    public let standalone: Bool
    public let hours: Int?
    public let regularPrice: Int?
    public let ticketPrice: Int?
}
