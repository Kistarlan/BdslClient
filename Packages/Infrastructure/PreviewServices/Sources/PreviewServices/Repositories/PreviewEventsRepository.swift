//
//  PreviewEventsRepository.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 25.02.2026.
//
import Foundation
import Models
import Services

final class PreviewEventsRepository: EventsRepository {
    let previewDataProvider: PreviewDataProvider

    init(previewDataProvider: PreviewDataProvider) {
        self.previewDataProvider = previewDataProvider
    }

    func fetchEvents() async throws -> [EventDTO] {
        do {
            let eventDtos = try previewDataProvider.load([EventDTO].self, from: "Events")
            return eventDtos
        } catch {
            print(error)

            throw error
        }
    }

    func fetchEventsFor(_ ids: [String]) async throws -> [EventDTO] {
        let allEvents = try await fetchEvents()

        return allEvents.filter { event in
            ids.contains(event.id)
        }
    }

    func fetchActualEvents(minEndDate: Date, _ exceptIds: [String]) async throws -> [Models.EventDTO] {
        let allEvents = try await fetchEvents()
        return allEvents.filter { event in
            !exceptIds.contains(event.id)
                && event.endDate > minEndDate
        }
    }
}
