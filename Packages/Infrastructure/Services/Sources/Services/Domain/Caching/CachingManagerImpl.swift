//
//  CachingManagerImpl.swift
//  Services
//
//  Created by Oleh Rozkvas on 16.03.2026.
//

public actor CachingManagerImpl: CachingManager {
    private var services: [any CacheableService] = []

    public init(services: [any CacheableService] = []) {
        self.services = services
    }

    public func clearFullCache() async {
        for service in services {
            await service.clearCache()
        }
    }

    public func clearUserCache() async {
        let userServices = services.compactMap { $0 as? UserCacheableService }

        for service in userServices {
            await service.clearUserCache()
        }
    }

    public func register(service: any CacheableService) {
        services.append(service)
    }
}
