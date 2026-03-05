//
//  LevelsRepository.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 25.02.2026.
//

import Models

public protocol LevelsRepository: Sendable {
    func fetchLevels() async throws -> [LevelDTO]
}
