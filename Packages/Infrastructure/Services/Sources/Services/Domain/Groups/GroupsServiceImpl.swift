//
//  GroupsServiceImpl.swift
//  Services
//
//  Created by Oleh Rozkvas on 19.03.2026.
//

import OSLog
import Models

final class GroupsServiceImpl: GroupsService {
    private let logger = Logger.forCategory(String(describing: GroupsService.self))
    private let cache = Cache<String, GroupModel>()
    private let groupsRepository: GroupsRepository

    init(groupsRepository: GroupsRepository) {
        self.groupsRepository = groupsRepository
    }

    func fetchGroups(forceReload: Bool) async throws -> [GroupModel] {
        let isEmpty = await cache.isEmpty

        if !forceReload && !isEmpty  {
            return await cache.getAll()
        }

        let dtos = try await groupsRepository.fetchGroups()

        await cache.clear()

        for dto in dtos {
            await cache.add(key: dto.id, value: dto.toDomain())
        }

        return await cache.getAll()
    }

    func clearCache() async {
        await cache.clear()
    }
}
