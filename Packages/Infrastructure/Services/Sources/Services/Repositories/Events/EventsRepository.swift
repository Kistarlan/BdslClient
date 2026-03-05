//
//  EventsRepository.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 25.02.2026.
//

import Models
import Foundation

public protocol EventsRepository: Sendable {
    func fetchEvents() async throws -> [EventDTO]
    func fetchEventsFor(_ ids: [String]) async throws -> [EventDTO]
    func fetchActualEvents(minEndDate: Date, _ exceptIds: [String]) async throws -> [EventDTO]
}
