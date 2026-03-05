//
//  EventsRepositoryImpl.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 25.02.2026.
//
import Models
import Foundation
import MongoFilters

final class EventsRepositoryImpl : EventsRepository {
    let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func fetchEvents() async throws -> [EventDTO] {
        return try await fetchEvents(nil)
    }

    func fetchEventsFor(_ ids: [String]) async throws -> [EventDTO] {
        return try await fetchEvents(Filter.In("_id", ids))
    }

    func fetchActualEvents(minEndDate: Date, _ exceptIds: [String]) async throws -> [EventDTO] {
        let filter: MongoFilter = Filter.and(
            Filter.nin("_id", exceptIds),
            Filter.nin("type", [EventType.rent]),
            Filter.GreaterThanOrEqual("recurrence.until", mongoDateFormat(minEndDate))
        )

        return try await fetchEvents(filter)
    }

    private func fetchEvents(_ filter: MongoFilter?) async throws -> [Models.EventDTO] {
        let query = filter != nil ? ["filter": try! filter!.makeFilterQuery()] : [:]

        let endpoint = Endpoint(
            path: "/events",
            method: .get,
            query: query
        )

        return try await apiClient.request(endpoint)
    }

    private func mongoDateFormat(_ date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]

        return formatter.string(from: date)
    }
}
