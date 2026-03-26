//
//  ActivityServiceImpl.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 02.03.2026.
//

import Models
import OSLog

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

        try await loadCache()

        guard let activity = await cache[id] else {
            throw ActivityServiceError.notFound(id: id)
        }

        return activity
    }

    func getAllActivities(forceReload: Bool) async throws -> [Activity] {
        if !forceReload {
            let activities = await cache.getAll()

            if !activities.isEmpty {
                return activities
            }
        }

        try await loadCache()

        return await cache.getAll()
    }

    func loadCache() async throws {
        let dtos = try await activityRepository.fetchActivities()

        await cache.clear()

        for dto in dtos {
            await cache.add(key: dto.id, value: dto.toDomain())
        }
    }

    func clearCache() async {
        await cache.clear()
    }
}

enum ActivityServiceError: Error {
    case notFound(id: String)
}
