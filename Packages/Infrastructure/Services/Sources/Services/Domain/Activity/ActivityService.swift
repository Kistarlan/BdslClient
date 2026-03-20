//
//  ActivityService.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 02.03.2026.
//

import Models

public protocol ActivityService : CacheableService {
    func getActivity(id: String, forceReload: Bool) async throws -> Activity
    func getAllActivities(forceReload: Bool) async throws -> [Activity]
}
