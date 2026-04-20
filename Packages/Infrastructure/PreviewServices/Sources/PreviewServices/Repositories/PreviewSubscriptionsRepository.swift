//
//  PreviewSubscriptionsRepository.swift
//  PreviewServices
//
//  Created by Oleh Rozkvas on 20.04.2026.
//

import Models
import Services

final class PreviewSubscriptionsRepository: SubscriptionsRepository {
    let previewDataProvider: PreviewDataProvider

    init(previewDataProvider: PreviewDataProvider) {
        self.previewDataProvider = previewDataProvider
    }

    func fetchSettings() async throws -> SubscriptionSettings {
        let dtos = try previewDataProvider.load([SettingDTO].self, from: "Settings")
        return dtos.toDomain()
    }
}
