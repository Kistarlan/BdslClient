//
//  SubscriptionsServiceImpl.swift
//  Services
//
//  Created by Oleh Rozkvas on 20.04.2026.
//

import Models
import OSLog

final class SubscriptionsServiceImpl: SubscriptionsService {
    private let logger = Logger.forCategory(String(describing: SubscriptionsServiceImpl.self))
    private let eventsService: EventsService
    private let subscriptionsRepository: SubscriptionsRepository

    private let activityCache = Cache<String, ActivitySubscription>()
    private let courseCache = Cache<String, CourseSubscription>()

    init(eventsService: EventsService, subscriptionsRepository: SubscriptionsRepository) {
        self.eventsService = eventsService
        self.subscriptionsRepository = subscriptionsRepository
    }

    func fetchAvailableSubscriptions(forceReload: Bool) async throws -> ([ActivitySubscription], [CourseSubscription]) {
        if forceReload {
            await activityCache.clear()
            await courseCache.clear()
        } else  {
            let isActivitiesEmpty = await activityCache.isEmpty
            let isCoursesEmpty = await courseCache.isEmpty

            if !isActivitiesEmpty || !isCoursesEmpty {
                return (await activityCache.getAll(), await courseCache.getAll())
            }
        }

        let events = try await eventsService.fetchActualEvents(forceReload: forceReload)

        for event in events {
            if let subscription = event.eventSubscription {
                await courseCache.add(
                    key: subscription.id,
                    value: CourseSubscription(
                        activity: event.activity,
                        subscription: subscription,
                        title: event.title
                    )
                )
            } else {
                await activityCache.add(
                    key: event.activity.id,
                    value: ActivitySubscription(
                        activity: event.activity,
                        title: event.activity.title
                    )
                )
            }
        }

        return (await activityCache.getAll(), await courseCache.getAll())
    }

    func fetchSettings() async throws -> SubscriptionSettings {
        return try await subscriptionsRepository.fetchSettings()
    }

    func requestOrder(
        userId: String,
        activities: [ActivitySubscription],
        courses: [CourseSubscription],
        price: Int,
        unlim: Bool
    ) async throws -> OrderResponseDTO {
        let line = OrderLineDTO(
            type: .userSubscription,
            activities: activities.map(\.id),
            groups: courses.map(\.id),
            unlim: unlim,
            extraHours: 0,
            price: price
        )
        let requestModel = OrderRequestDTO(
            user: userId,
            recurrentPayCount: 0,
            lines: [line]
        )
        return try await subscriptionsRepository.requestOrder(requestModel: requestModel)
    }

    func clearCache() async {
        await activityCache.clear()
        await courseCache.clear()
    }
}
