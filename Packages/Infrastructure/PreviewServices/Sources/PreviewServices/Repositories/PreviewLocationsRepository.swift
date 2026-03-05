//
//  PreviewLocationsRepository.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 25.02.2026.
//

import Models
import Services

final class PreviewLocationsRepository: LocationsRepository {
    let previewDataProvider: PreviewDataProvider

    init(previewDataProvider: PreviewDataProvider) {
        self.previewDataProvider = previewDataProvider
    }

    func fetchLocations() async throws -> [LocationDTO] {
        let dtos = try previewDataProvider.load([LocationDTO].self, from: "Locations")

        return dtos
    }
}
