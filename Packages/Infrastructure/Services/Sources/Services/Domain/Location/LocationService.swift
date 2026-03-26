//
//  LocationService.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 02.03.2026.
//

import Models

public protocol LocationService: CacheableService {
    func getLocaction(id: String, forceReload: Bool) async throws -> Location
}
