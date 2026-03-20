//
//  PreviewGroupsRepository.swift
//  PreviewServices
//
//  Created by Oleh Rozkvas on 19.03.2026.
//

import Models
import Services

final class PreviewGroupsRepository : GroupsRepository {
    let previewDataProvider: PreviewDataProvider

    init(previewDataProvider: PreviewDataProvider) {
        self.previewDataProvider = previewDataProvider
    }

    func fetchGroups() async throws -> [GroupDTO] {
        let dtos = try previewDataProvider.load([GroupDTO].self, from: "Groups")

        return dtos
    }
}
