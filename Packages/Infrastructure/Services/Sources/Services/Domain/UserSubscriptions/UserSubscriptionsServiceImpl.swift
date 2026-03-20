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
    private let userSubscriptionsCache = Cache<String, [UserSubscription]>()

    private let logger = Logger.forCategory(String(describing: UserSubscriptionsServiceImpl.self))
    private let userSubscriptionsRepository: UserSubscriptionsRepository
    private let eventsService: EventsService

    init(userSubscriptionsRepository: UserSubscriptionsRepository,
         eventsService: EventsService) {
        self.userSubscriptionsRepository = userSubscriptionsRepository
        self.eventsService = eventsService
    }

    func fetchUserSubscriptions(for id: String, forceReload: Bool) async throws -> [UserSubscription] {
        if let cached = await userSubscriptionsCache[id] {
            return cached
        }

        let dtos = try await userSubscriptionsRepository.fetchUserSubscriptions(for: id)
        let subscriptions = dtos.map { $0.toDomain() }

        await userSubscriptionsCache.add(key: id, value: subscriptions)

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

        let attendeeDtos: [AttendeeDTO] = try await userSubscriptionsRepository.fetchSubscriptionAttendees(for: userSubscription.userId)
        let eventIds = attendeeDtos.compactMap {
            $0.eventId.split(separator: ".").first.map(String.init)
        }
        let events: [EventModel] = try await eventsService.fetchEvents(for: eventIds, forceReload: forceReload)
        let subscriptionsCache: [UserSubscription] = try await fetchUserSubscriptions(for: userSubscription.userId, forceReload: forceReload)


        for subscription in subscriptionsCache {
            let filteredDtos = attendeeDtos.filter{
                subscription.visitsIds.contains($0.id)
            }

            let attendees = buildAttendeeModels(dtos: filteredDtos, events: events)

            await attendeesCache.add(key: subscription, value: attendees)
        }

        if let attendees = await attendeesCache[userSubscription] {
            return attendees
        } else {
            throw UserSubscriptionsServiceError.noData(id: userSubscription.id)
        }
    }

    func buildAttendeeModels(dtos: [AttendeeDTO], events: [EventModel]) -> [AttendeeModel] {
        var attendeeModels = [AttendeeModel]()

        for attendee in dtos {
            guard let enroll = attendee.enroll,
                  let eventId = attendee.eventId.split(separator: ".").first.map(String.init),
                  let event = events.first(where: { $0.id == eventId }) else {
                continue
            }

            attendeeModels.append( AttendeeModel(id: attendee.id,
                                                 status: attendee.status,
                                                 event: event,
                                                 enrollTime: enroll.time))
        }

        return attendeeModels
    }

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
}
