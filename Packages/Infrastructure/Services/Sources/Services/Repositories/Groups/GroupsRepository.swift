//
//  GroupsRepository.swift
//  Services
//
//  Created by Oleh Rozkvas on 19.03.2026.
//

import Models

public protocol GroupsRepository : Sendable {
    func fetchGroups() async throws -> [GroupDTO]
}
