//
//  MockGroupsService.swift
//  BdslClientTests
//

import Models
import Services

final class MockGroupsService: GroupsService, @unchecked Sendable {
    var fetchGroupsResult: Result<[GroupModel], Error> = .success([])

    func fetchGroups(forceReload: Bool) async throws -> [GroupModel] {
        try fetchGroupsResult.get()
    }

    func clearCache() async {}
}
