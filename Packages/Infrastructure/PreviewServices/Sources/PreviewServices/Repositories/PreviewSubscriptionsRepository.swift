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

    func requestOrder(requestModel: OrderRequestDTO) async throws -> OrderResponseDTO {
        OrderResponseDTO(
            id: "preview-order-id",
            user: requestModel.user,
            createdBy: requestModel.user,
            recurrentPayCount: requestModel.recurrentPayCount,
            totalPrice: requestModel.lines.first?.price ?? 0,
            status: "new",
            invoice: "preview-invoice-id",
            invoiceUrl: "https://secure.wayforpay.com/invoice/preview",
            lines: []
        )
    }
}
