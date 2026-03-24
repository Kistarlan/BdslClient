//
//  UserSubscriptionsServiceImpl.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 25.02.2026.
//

import Foundation
import OSLog
import Models

final class UserSubscriptionsServiceImpl : UserSubscriptionsService {
    private let attendeesCache = Cache<UserSubscription, [AttendeeModel]>()
    private let classesCache = Cache<String, ClassModel>()
    private let userSubscriptionsCache = Cache<String, UserSubscription>()

    private let logger = Logger.forCategory(String(describing: UserSubscriptionsServiceImpl.self))
    private let userSubscriptionsRepository: UserSubscriptionsRepository
    private let eventsService: EventsService
    private let activityService: ActivityService

    init(userSubscriptionsRepository: UserSubscriptionsRepository,
         eventsService: EventsService,
         activityService: ActivityService) {
        self.userSubscriptionsRepository = userSubscriptionsRepository
        self.eventsService = eventsService
        self.activityService = activityService
    }

    func fetchUserSubscriptions(for userId: String, forceReload: Bool) async throws -> [UserSubscription] {
        let isCacheEmpty = await userSubscriptionsCache.isEmpty
        if !forceReload && !isCacheEmpty {
            return await userSubscriptionsCache.getAll()
        }

        let subscriptions = try await fetchSubscriptions(for: userId, forceReload: forceReload)

        return subscriptions.filter { subscription in
            if subscription.category == .credit &&
                subscription.closed == true {
                return false
            } else {
                return true
            }
        }
    }

    func fetchSubscriptionAttendees(userSubscription: UserSubscription, forceReload: Bool) async throws -> [AttendeeModel] {
        if !forceReload,
           let cached = await attendeesCache[userSubscription] {
            return cached
        }

        try await fetchClassAttendees(userId: userSubscription.userId, forceReload: forceReload)

        if let attendees = await attendeesCache[userSubscription] {
            return attendees
        } else {
            throw UserSubscriptionsServiceError.noData(id: userSubscription.id)
        }
    }

    func loadUpcommingClasses(for userId: String, forceReload: Bool) async throws -> [UpcomingClassModel] {
        let isCacheEmpty = await classesCache.isEmpty

        if forceReload || isCacheEmpty {
            try await fetchClassAttendees(userId: userId, forceReload: forceReload)
        }

        let userClasses = await classesCache.getAll()

        let actualClasses = userClasses.filter { $0.event.weeklyReccurance.untilDate > Date() }

        let generator = UpcomingClassesGenerator()

        let upcommingClasses = generator.generate(
            from: actualClasses,
            now: Date()
        )

        return upcommingClasses.sorted { return $0.concreateTime > $1.concreateTime}
    }

    //MARK: - load data from repositories and fill cache
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
        let subscriptionsCache: [UserSubscription] = try await fetchUserSubscriptions(for: userId, forceReload: forceReload)

        await attendeesCache.clear()

        for subscription in subscriptionsCache {
            let filteredAttendees = attendeeDtos.filter{
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
            guard let parsedId = try? parseAttendeeId(dto.id),
                  let event = events.first(where: { $0.id == parsedId.eventId }),
                  dto.enroll == nil else {
                continue
            }

            classModels.append( ClassModel(id: dto.id,
                                           event: event,
                                           concreateTime: parsedId.eventTime))
        }

        return classModels
    }

    func buildAttendeeModels(_ dtos: [AttendeeDTO], _ events: [EventModel]) -> [AttendeeModel] {
        var attendeeModels = [AttendeeModel]()

        for attendee in dtos {
            guard let parsedId = try? parseAttendeeId(attendee.id),
                  let event = events.first(where: { $0.id == parsedId.eventId }),
                  let enroll = attendee.enroll else {
                continue
            }

            attendeeModels.append( AttendeeModel(id: attendee.id,
                                                 event: event,
                                                 enrollTime: enroll.time))
        }

        return attendeeModels
    }

    func parseAttendeeId(_ id: String) throws -> (eventId: String, eventTime: Date?, userId: String) {
        let parts = id.split(separator: ":")
        guard parts.count == 2 else { throw UserSubscriptionsServiceError.attendeeParseError(id: id) }

        let leftParts = parts[0].split(separator: ".")

        let eventId = String(leftParts[0])
        let eventTime = leftParts.count > 1 ? parseDate(String(leftParts[1])) : nil
        let userId = String(parts[1])

        return (eventId, eventTime, userId)
    }

    func parseDate(_ value: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.date(from: value)
    }

//MARK: - clear cache
    func clearCache() async {
        await attendeesCache.clear()
        await userSubscriptionsCache.clear()
    }

    func clearUserCache() async {
        await clearCache()
    }
}

enum UserSubscriptionsServiceError : Error {
    case noData(id: String)
    case attendeeParseError(id: String)
}
