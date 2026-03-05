//
//  PreviewActivityRepository.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 25.02.2026.
//
import Models
import Services

final class PreviewActivityRepository: ActivityRepository {
    let previewDataProvider: PreviewDataProvider

    init(previewDataProvider: PreviewDataProvider) {
        self.previewDataProvider = previewDataProvider
    }

    func fetchActivities() async throws -> [ActivityDTO] {
        let dtos = try previewDataProvider.load([ActivityDTO].self, from: "Activities")

        return dtos
    }
}
