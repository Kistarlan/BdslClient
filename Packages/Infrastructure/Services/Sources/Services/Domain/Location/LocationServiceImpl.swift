//
//  LocationServiceImpl.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 02.03.2026.
//

import OSLog
import Models

final class LocationServiceImpl: LocationService {
    private let logger = Logger.forCategory(String(describing: LocationServiceImpl.self))
    private let cache = Cache<String, Location>()
    private let locationsRepository: LocationsRepository

    init(locationsRepository: LocationsRepository) {
        self.locationsRepository = locationsRepository
    }

    func getLocaction(id: String, forceReload: Bool) async throws -> Location {
        if forceReload {
            await clearCache()
        } else {
            if let location = await cache[id] {
                return location
            }
        }

        let dtos = try await locationsRepository.fetchLocations()

        for dto in dtos {
            await cache.add(key: dto.id, value: dto.toDomain())
        }

        guard let location = await cache[id] else {
            throw LocationServiceError.notFound(id: id)
        }

        return location
    }

    func clearCache() async {
        await cache.clear()
    }
}

enum LocationServiceError: Error {
    case notFound(id: String)
}
