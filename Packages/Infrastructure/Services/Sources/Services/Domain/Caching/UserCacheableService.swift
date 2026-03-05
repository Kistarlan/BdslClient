//
//  UserCacheableService.swift
//  Services
//
//  Created by Oleh Rozkvas on 16.03.2026.
//

public protocol UserCacheableService: Sendable {
    func clearUserCache() async
}
