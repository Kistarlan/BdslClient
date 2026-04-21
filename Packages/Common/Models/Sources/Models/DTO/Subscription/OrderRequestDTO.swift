//
//  OrderRequestDTO.swift
//  Models
//
//  Created by Oleh Rozkvas on 20.04.2026.
//

public enum OrderLineType: String, Encodable, Sendable {
    case userSubscription = "UserSubscription"
    case rent = "Rent"
}

public struct OrderRequestDTO: Encodable, Sendable {
    public let user: String
    public let recurrentPayCount: Int
    public let lines: [OrderLineDTO]

    public init(user: String, recurrentPayCount: Int, lines: [OrderLineDTO]) {
        self.user = user
        self.recurrentPayCount = recurrentPayCount
        self.lines = lines
    }
}

public struct OrderLineDTO: Encodable, Sendable {
    public let type: OrderLineType
    public let activities: [String]
    public let groups: [String]
    public let unlim: Bool
    public let extraHours: Int
    public let price: Int

    public init(
        type: OrderLineType,
        activities: [String],
        groups: [String],
        unlim: Bool,
        extraHours: Int,
        price: Int
    ) {
        self.type = type
        self.activities = activities
        self.groups = groups
        self.unlim = unlim
        self.extraHours = extraHours
        self.price = price
    }
}
