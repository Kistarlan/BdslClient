//
//  EventSubscriptionDTO.swift
//  Models
//
//  Created by Oleh Rozkvas on 20.04.2026.
//

public struct EventSubscriptionDTO: Identifiable, Decodable {
    public let id: String
    public let standalone: Bool
    public let hours: Int?
    public let regularPrice: Int?
    public let ticketPrice: Int?

    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case standalone
        case hours
        case regularPrice
        case ticketPrice
    }
}

public extension EventSubscriptionDTO {
    func toDomain() -> EventSubscription {
        .init(
            id: id,
            standalone: standalone,
            hours: hours,
            regularPrice: regularPrice,
            ticketPrice: ticketPrice
        )
    }
}
