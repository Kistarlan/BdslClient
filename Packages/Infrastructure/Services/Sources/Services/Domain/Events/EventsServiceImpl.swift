//
//  EventsServiceImpl.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 25.02.2026.
//

import Foundation
import Models
import OSLog

final class EventsServiceImpl: EventsService {
    private let logger = Logger.forCategory(String(describing: EventsServiceImpl.self))

    private let cache = Cache<String, EventModel>()

    private let eventsRepository: EventsRepository
    private let teacherService: TeachersService
    private let activityService: ActivityService
    private let locationsService: LocationService
    private let levelsService: LevelsService

    init(
        eventsRepository: EventsRepository,
        teacherService: TeachersService,
        activityService: ActivityService,
        locationsService: LocationService,
        levelsService: LevelsService
    ) {
        self.eventsRepository = eventsRepository
        self.teacherService = teacherService
        self.activityService = activityService
        self.locationsService = locationsService
        self.levelsService = levelsService
    }

    func fetchEvent(for id: String, forceReload: Bool) async throws -> EventModel {
        let events = try await fetchEvents(for: [id], forceReload: forceReload)

        if let event = events.first(where: { $0.id == id }) {
            return event
        } else {
            throw EventsServiceErrors.eventNotFoundError(id: id)
        }
    }

    func fetchActualEvents(forceReload: Bool) async throws -> [EventModel] {
        let cacheIds = await cache.getAllKeys()

        if forceReload {
            for id in cacheIds {
                await cache.remove(forKey: id)
            }
        }

        let dtos = try await eventsRepository.fetchActualEvents(minEndDate: Date(), forceReload ? [] : cacheIds)

        for eventDTO in dtos {
            do {
                try Task.checkCancellation()

                if let model = await buildEventModel(from: eventDTO) {
                    await cache.add(key: model.id, value: model)
                }

                try Task.checkCancellation()
            } catch is CancellationError {
                await cache.clear()
            }
        }

        let cachedEvents = await cache.getAll()

        let actualEvents = cachedEvents.filter { $0.weeklyReccurance.untilDate >= Date() }

        return actualEvents
    }

    func fetchEvents(for ids: [String], forceReload: Bool) async throws -> [EventModel] {
        if forceReload {
            for id in ids {
                await cache.remove(forKey: id)
            }

            await clearCacheInSubServices()
        }

        var cachedEvents: [EventModel] = []
        var missedEventIds: [String] = []

        for ids in ids {
            if let event = await cache[ids] {
                cachedEvents.append(event)
            } else {
                missedEventIds.append(ids)
            }
        }

        if !missedEventIds.isEmpty {
            let dtos = try await eventsRepository.fetchEventsFor(missedEventIds)

            for eventDTO in dtos {
                if let model = await buildEventModel(from: eventDTO) {
                    await cache.add(key: model.id, value: model)
                    cachedEvents.append(model)
                }
            }
        }

        return cachedEvents
    }

    private func clearCacheInSubServices() async {
        await teacherService.clearCache()
        await locationsService.clearCache()
        await activityService.clearCache()
        await levelsService.clearCache()
    }

    private func buildEventModel(from dto: EventDTO) async -> EventModel? {
        guard
            dto.type != .rent,
            let title = dto.title,
            let recurrence = getWeeklyRecurrenceOrDefault(for: dto),
            let teachers = await getTeachersOrDefault(for: dto),
            let location = await getLocationOrDefault(for: dto),
            let activity = await getActivityOrDefault(for: dto),
            let level = await getLevelOrDefault(for: dto)
        else {
            return nil
        }

        return EventModel(
            id: dto.id,
            teachers: teachers,
            type: dto.type,
            weeklyReccurance: recurrence,
            startDate: dto.startDate,
            endDate: dto.endDate,
            location: location,
            level: level,
            title: title,
            activity: activity,
            eventSubscription: dto.subscription?.toDomain() ?? nil
        )
    }

    func getTeachersOrDefault(for eventDTO: EventDTO) async -> [TeacherModel]? {
        var teachers: [TeacherModel] = []
        guard let teacherIds = eventDTO.teacherIds else {
            return nil
        }

        for teacherId in teacherIds {
            do {
                let teacher = try await teacherService.fetchTeacher(for: teacherId)
                teachers.append(teacher)
            } catch {
                logger.warning("Can't load teacherModel for id = \(teacherId)")

                return nil
            }
        }

        return teachers.count == 0 ? nil : teachers
    }

    func getWeeklyRecurrenceOrDefault(for eventDTO: EventDTO) -> WeeklyRecurrence? {
        guard let recurrenceDTO = eventDTO.recurrence else {
            logger.warning("Can't find reccurence for event.id: \(eventDTO.id)")

            return nil
        }

        if case let .weekly(recurrence) = recurrenceDTO {
            return WeeklyRecurrence(
                id: recurrence.id,
                interval: recurrence.interval,
                untilDate: recurrence.untilDate,
                days: recurrence.days
            )
        }

        logger.warning("This type of reccurence not implemented yet \(recurrenceDTO.id)")

        return nil
    }

    func getLocationOrDefault(for eventDTO: EventDTO) async -> Location? {
        do {
            return try await locationsService.getLocaction(id: eventDTO.locationId, forceReload: false)
        } catch {
            logger.warning("Can't load locationModel for id = \(eventDTO.locationId)")

            return nil
        }
    }

    func getActivityOrDefault(for eventDTO: EventDTO) async -> Activity? {
        guard let activityId = eventDTO.activityId else {
            logger.warning("Can't load Activity for eventDTO.id = \(eventDTO.id)")
            return nil
        }

        do {
            return try await activityService.getActivity(id: activityId, forceReload: false)
        } catch {
            logger.warning("Can't load activityModel for id = \(activityId)")

            return nil
        }
    }

    func getLevelOrDefault(for eventDTO: EventDTO) async -> Level? {
        guard let levelId = eventDTO.levelId else {
            logger.warning("Can't load Level for eventDTO.id = \(eventDTO.id)")
            return nil
        }

        do {
            return try await levelsService.getLevel(id: levelId, forceReload: false)
        } catch {
            logger.warning("Can't load levelModel for id = \(levelId)")

            return nil
        }
    }

    func clearCache() async {
        await cache.clear()
    }
}

enum EventsServiceErrors: Error {
    case eventNotFoundError(id: String)
}
