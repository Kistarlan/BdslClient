//
//  CachingManager.swift
//  Services
//
//  Created by Oleh Rozkvas on 16.03.2026.
//

public protocol CachingManager: Sendable {
    func clearFullCache() async
    func clearUserCache() async
    func register(service: any CacheableService) async
}
