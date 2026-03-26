//
//  GroupsService.swift
//  Services
//
//  Created by Oleh Rozkvas on 19.03.2026.
//

import Foundation
import Models

public protocol GroupsService: CacheableService {
    func fetchGroups(forceReload: Bool) async throws -> [GroupModel]
}
