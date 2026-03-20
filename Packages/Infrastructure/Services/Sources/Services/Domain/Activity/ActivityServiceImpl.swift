//
//  DefaultActivityService.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 02.03.2026.
//

import OSLog
import Models

final class ActivityServiceImpl: ActivityService {
    private let logger = Logger.forCategory(String(describing: ActivityServiceImpl.self))
    private let cache = Cache<String, Activity>()
    private let activityRepository: ActivityRepository

    init(activityRepository: ActivityRepository) {
        self.activityRepository = activityRepository
    }

    func getActivity(id: String, forceReload: Bool) async throws -> Activity {
        if !forceReload, let activity = await cache[id] {
            return activity
        }

        let dtos = try await activityRepository.fetchActivities()

        let activities = dtos.map { $0.toDomain() }

        await cache.clear()

        for activity in activities {
            await cache.add(key: activity.id, value: activity)
        }

        guard let activity = await cache[id] else {
            throw ActivityServiceError.notFound(id: id)
        }

        return activity
    }

    func clearCache() async {
        await cache.clear()
    }
}

enum ActivityServiceError: Error {
    case notFound(id: String)
}
