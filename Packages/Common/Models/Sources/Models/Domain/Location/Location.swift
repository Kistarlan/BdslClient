//
//  Location.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 20.02.2026.
//

public struct Location: Hashable, Sendable {
    public let id: String
    public let title: String
    public let address: String
    public let colorHex: String
    public let color2Hex: String

    public init(
        id: String,
        title: String,
        address: String,
        colorHex: String,
        color2Hex: String,
    ) {
        self.id = id
        self.title = title
        self.address = address
        self.colorHex = colorHex
        self.color2Hex = color2Hex
    }
}
