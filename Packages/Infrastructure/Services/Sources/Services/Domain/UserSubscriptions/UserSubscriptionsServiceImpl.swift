//
//  UserSubscriptionsServiceImpl.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 25.02.2026.
//

import Foundation
import Models
import OSLog

final class UserSubscriptionsServiceImpl: UserSubscriptionsService {
    private let attendeesCache = Cache<UserSubscription, [AttendeeModel]>()
    private let classesCache = Cache<String, ClassModel>()
    private let userSubscriptionsCache = Cache<String, UserSubscription>()

    private let logger = Logger.forCategory(String(describing: UserSubscriptionsServiceImpl.self))
    private let userSubscriptionsRepository: UserSubscriptionsRepository
    private let eventsService: EventsService
    private let activityService: ActivityService
    private let upcommingClassGenerator: UpcomingClassesGenerating

    init(
        userSubscriptionsRepository: UserSubscriptionsRepository,
        eventsService: EventsService,
        activityService: ActivityService,
        upcommingClassGenerator: UpcomingClassesGenerating
    ) {
        self.userSubscriptionsRepository = userSubscriptionsRepository
        self.eventsService = eventsService
        self.activityService = activityService
        self.upcommingClassGenerator = upcommingClassGenerator
    }

    func fetchUserSubscriptions(for userId: String, forceReload: Bool) async throws -> [UserSubscription] {
        let isCacheEmpty = await userSubscriptionsCache.isEmpty
        if !forceReload, !isCacheEmpty {
            return await userSubscriptionsCache.getAll()
        }

        let subscriptions = try await fetchSubscriptions(for: userId, forceReload: forceReload)

        return subscriptions.filter { subscription in
            if subscription.category == .credit,
               subscription.closed == true
            {
                return false
            } else {
                return true
            }
        }
    }

    func fetchSubscriptionAttendees(
        userSubscription: UserSubscription,
        forceReload: Bool
    ) async throws -> [AttendeeModel] {
        if !forceReload,
           let cached = await attendeesCache[userSubscription]
        {
            return cached
        }

        try await fetchClassAttendees(userId: userSubscription.userId, forceReload: forceReload)

        if let attendees = await attendeesCache[userSubscription] {
            return attendees
        } else {
            throw UserSubscriptionsServiceError.noData(id: userSubscription.id)
        }
    }

    func loadUpcomingClasses(
        for userId: String,
        range: ClassGeneratingRange,
        forceReload: Bool
    ) async throws -> [UpcomingClassModel] {
        let isCacheEmpty = await classesCache.isEmpty

        if forceReload || isCacheEmpty {
            try await fetchClassAttendees(userId: userId, forceReload: false)
        }

        let userClasses = await classesCache.getAll()
        let actual = userClasses.filter {
            $0.event.weeklyReccurance.untilDate > Date()
        }

        let upcommingClasses = upcommingClassGenerator.generate(
            from: actual,
            now: Date(),
            horizon: getHorizonForClassGenerating(range)
        )

        logger.info("Loaded \(upcommingClasses.count) upcoming classes from \(actual.count) instances for \(range.description) range")

        return upcommingClasses
    }

    private func getHorizonForClassGenerating(_ range: ClassGeneratingRange) -> TimeInterval {
        switch range {
        case .week:
            return TimeInterval.week
        case .endOfWeek:
            return TimeInterval.endOfWeek
        case .month:
            return TimeInterval.month
        case let .days(daysCount):
            return TimeInterval.from(days: daysCount)
        }
    }

    // MARK: - load data from repositories and fill cache

    func fetchSubscriptions(for id: String, forceReload: Bool) async throws -> [UserSubscription] {
        let dtos = try await userSubscriptionsRepository.fetchUserSubscriptions(for: id)

        try Task.checkCancellation()

        let activities = try await activityService.getAllActivities(forceReload: forceReload)

        try Task.checkCancellation()

        await userSubscriptionsCache.clear()

        for dto in dtos {
            let subscriptionActivities = activities.filter {
                dto.activityIds.contains($0.id)
            }

            await userSubscriptionsCache.add(key: dto.id, value: dto.toDomain(subscriptionActivities))
        }

        return await userSubscriptionsCache.getAll()
    }

    func fetchClassAttendees(userId: String, forceReload: Bool) async throws {
        let attendeeDtos: [AttendeeDTO] = try await userSubscriptionsRepository.fetchSubscriptionAttendees(for: userId)
        let eventIds = attendeeDtos.compactMap {
            $0.eventId.split(separator: ".").first.map(String.init)
        }
        let events: [EventModel] = try await eventsService.fetchEvents(for: eventIds, forceReload: forceReload)
        let subscriptionsCache: [UserSubscription] = try await fetchUserSubscriptions(
            for: userId,
            forceReload: forceReload
        )

        await attendeesCache.clear()

        for subscription in subscriptionsCache {
            let filteredAttendees = attendeeDtos.filter {
                subscription.visitsIds.contains($0.id)
            }

            await attendeesCache.add(key: subscription, value: buildAttendeeModels(filteredAttendees, events))
        }

        let classModels = buildClassModels(attendeeDtos, events)

        await classesCache.clear()

        for classModel in classModels {
            await classesCache.add(key: classModel.id, value: classModel)
        }
    }

    func buildClassModels(_ dtos: [AttendeeDTO], _ events: [EventModel]) -> [ClassModel] {
        var classModels = [ClassModel]()

        for dto in dtos.filter({ $0.status == .suggested }) {
            guard let parsedId = try? dto.parseAttendeeId(),
                  let event = events.first(where: { $0.id == parsedId.eventId }),
                  dto.enroll == nil
            else {
                continue
            }

            classModels.append(ClassModel(
                id: dto.id,
                event: event,
                concreateTime: parsedId.eventTime
            ))
        }

        return classModels
    }

    func buildAttendeeModels(_ dtos: [AttendeeDTO], _ events: [EventModel]) -> [AttendeeModel] {
        var attendeeModels = [AttendeeModel]()

        for attendee in dtos {
            guard let parsedId = try? attendee.parseAttendeeId(),
                  let event = events.first(where: { $0.id == parsedId.eventId }),
                  let enroll = attendee.enroll
            else {
                continue
            }

            attendeeModels.append(AttendeeModel(
                id: attendee.id,
                event: event,
                enrollTime: enroll.time
            ))
        }

        return attendeeModels
    }

    // MARK: - clear cache

    func clearCache() async {
        await attendeesCache.clear()
        await userSubscriptionsCache.clear()
    }

    func clearUserCache() async {
        await clearCache()
    }
}

enum UserSubscriptionsServiceError: Error {
    case noData(id: String)
    case attendeeParseError(id: String)
}
