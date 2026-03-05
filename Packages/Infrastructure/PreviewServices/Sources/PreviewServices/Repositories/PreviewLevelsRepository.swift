//
//  PreviewLevelsRepository.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 25.02.2026.
//
import Models
import Services

final class PreviewLevelsRepository: LevelsRepository {
    let previewDataProvider: PreviewDataProvider

    init(previewDataProvider: PreviewDataProvider) {
        self.previewDataProvider = previewDataProvider
    }

    func fetchLevels() async throws -> [LevelDTO] {
        let dtos = try previewDataProvider.load([LevelDTO].self, from: "Levels")

        return dtos
    }
}
