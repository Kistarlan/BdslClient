//
//  LocationsRepository.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 25.02.2026.
//

import Models

public protocol LocationsRepository: Sendable {
    func fetchLocations() async throws -> [LocationDTO]
}
