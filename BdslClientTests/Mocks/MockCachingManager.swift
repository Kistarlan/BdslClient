//
//  MockCachingManager.swift
//  BdslClientTests
//

import Services

final class MockCachingManager: CachingManager, @unchecked Sendable {
    func clearFullCache() async {}
    func clearUserCache() async {}
    func register(service: any CacheableService) async {}
}
