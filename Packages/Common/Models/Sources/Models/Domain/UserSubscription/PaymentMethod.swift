//
//  PaymentMethod.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 20.02.2026.
//

public enum PaymentMethod: String, Codable, Sendable {
    case cash
    case card
    case online
    case wayforpay
    case bank
}
