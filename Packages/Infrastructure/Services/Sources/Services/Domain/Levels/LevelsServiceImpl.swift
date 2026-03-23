//
//  LevelsServiceImpl.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 01.03.2026.
//

import OSLog
import Models

final class LevelsServiceImpl: LevelsService {
    private let logger = Logger.forCategory(String(describing: LevelsServiceImpl.self))
    private let cache = Cache<String, Level>()
    private let levelsRepository: LevelsRepository

    init(levelsRepository: LevelsRepository) {
        self.levelsRepository = levelsRepository
    }

    func getLevel(id: String, forceReload: Bool) async throws -> Level {
        if forceReload {
            await clearCache()
        } else {
            if let level = await cache[id] {
                return level
            }
        }

        let dtos = try await levelsRepository.fetchLevels()

        let levels = dtos.map { $0.toDomain() }

        for level in levels {
            await cache.add(key: level.id, value: level)
        }

        guard let level = await cache[id] else {
            throw LevelServiceError.notFound(id: id)
        }

        return level
    }

    func clearCache() async {
        await cache.clear()
    }
}

enum LevelServiceError: Error {
    case notFound(id: String)
}
