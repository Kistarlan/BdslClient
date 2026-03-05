//
//  UserSubscriptionDTO.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 20.02.2026.
//

import Foundation

public enum UserSubscriptionDTO: Identifiable, Decodable {
    case regular(RegularSubscriptionDTO)
    case credit(CreditSubscriptionDTO)
    case volunteer(VolunteerSubscriptionDTO)
    case ticket(TicketSubscriptionDTO)

    public var id: String {
        switch self {
        case let .regular(model): return model.id
        case let .credit(model): return model.id
        case let .volunteer(model): return model.id
        case let .ticket(model): return model.id
        }
    }

    public var userId: String {
        switch self {
        case let .regular(model): return model.userId
        case let .credit(model): return model.userId
        case let .volunteer(model): return model.userId
        case let .ticket(model): return model.userId
        }
    }

    // MARK: - Custom decoding

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(SubscriptionType.self, forKey: .type)

        switch type {
        case .regular:
            self = try .regular(RegularSubscriptionDTO(from: decoder))
        case .credit:
            self = try .credit(CreditSubscriptionDTO(from: decoder))
        case .volunteer:
            self = try .volunteer(VolunteerSubscriptionDTO(from: decoder))
        case .ticket:
            self = try .ticket(TicketSubscriptionDTO(from: decoder))
        }
    }

    private enum CodingKeys: String, CodingKey {
        case type
    }
}

extension UserSubscriptionDTO {
    public func toDomain() -> UserSubscription {
        switch self {

        case .regular(let dto):
            return UserSubscription(
                id: dto.id,
                activityIds: dto.activityIds,
                visitsIds: dto.visitsIds,
                userId: dto.userId,
                title: dto.title,
                startDate: dto.startDate,

                endDate: dto.endDate,
                unlimited: dto.unlimited,
                visitsLimit: dto.visitsLimit,
                paymentMethod: dto.paymentMethod,
                price: dto.price,

                closed: nil,

                category: dto.endDate < Date() ? .expired : .active
            )

        case .credit(let dto):
            return UserSubscription(
                id: dto.id,
                activityIds: dto.activityIds,
                visitsIds: dto.visitsIds,
                userId: dto.userId,
                title: dto.title,
                startDate: dto.startDate,

                endDate: nil,
                unlimited: nil,
                visitsLimit: nil,
                paymentMethod: nil,
                price: nil,

                closed: dto.closed,

                category: .credit
            )

        case .volunteer(let dto):
            return UserSubscription(
                id: dto.id,
                activityIds: dto.activityIds,
                visitsIds: dto.visitsIds,
                userId: dto.userId,
                title: dto.title,
                startDate: dto.startDate,

                endDate: nil,
                unlimited: nil,
                visitsLimit: nil,
                paymentMethod: nil,
                price: nil,

                closed: nil,

                category: .volonteer
            )

        case .ticket(let dto):
            return UserSubscription(
                id: dto.id,
                activityIds: dto.activities,
                visitsIds: dto.visits,
                userId: dto.userId,
                title: dto.title,
                startDate: dto.startDate,

                endDate: nil,
                unlimited: nil,
                visitsLimit: nil,
                paymentMethod: nil,
                price: nil,

                closed: nil,

                category: .oneClassTicket
            )
        }
    }
}
