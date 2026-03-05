//
//  ActivityRepository.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 25.02.2026.
//
import Models

public protocol ActivityRepository: Sendable {
    func fetchActivities() async throws -> [ActivityDTO]
}
