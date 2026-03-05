//
//  EventsService.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 25.02.2026.
//

import Foundation
import Models

public protocol EventsService : CacheableService {
    func fetchEvent(for id: String, forceReload: Bool) async throws -> EventModel
    func fetchEvents(for ids: [String], forceReload: Bool) async throws -> [EventModel]
    func fetchActualEvents(forceReload: Bool) async throws -> [EventModel]
}
