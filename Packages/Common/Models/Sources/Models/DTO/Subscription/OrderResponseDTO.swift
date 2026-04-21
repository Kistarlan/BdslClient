//
//  OrderResponseDTO.swift
//  Models
//
//  Created by Oleh Rozkvas on 20.04.2026.
//

import Foundation

public struct OrderResponseDTO: Decodable, Sendable {
    public let id: String
    public let user: String
    public let createdBy: String
    public let recurrentPayCount: Int
    public let totalPrice: Int
    public let status: String
    public let invoice: String
    public let invoiceUrl: String
    public let lines: [OrderLineResponseDTO]

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case user
        case createdBy
        case recurrentPayCount
        case totalPrice
        case status
        case invoice
        case invoiceUrl
        case lines
    }
}

public struct OrderLineResponseDTO: Decodable, Sendable {
    public let id: String
    public let type: String
    public let activities: [String]
    public let groups: [String]
    public let unlim: Bool
    public let extraHours: Int
    public let price: Int
    public let userSubscriptions: [String]

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case type
        case activities
        case groups
        case unlim
        case extraHours
        case price
        case userSubscriptions
    }
}
