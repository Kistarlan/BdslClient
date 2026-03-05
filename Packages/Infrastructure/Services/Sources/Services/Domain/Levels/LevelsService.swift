//
//  LevelsService.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 01.03.2026.
//
import Models

public protocol LevelsService : CacheableService {
    func getLevel(id: String, forceReload: Bool) async throws -> Level
}
