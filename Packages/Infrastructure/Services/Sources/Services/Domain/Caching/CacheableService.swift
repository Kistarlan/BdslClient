//
//  CacheableService.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 27.02.2026.
//

public protocol CacheableService: Sendable {
    func clearCache() async
}
