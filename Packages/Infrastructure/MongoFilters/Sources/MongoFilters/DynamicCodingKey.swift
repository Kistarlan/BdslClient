//
//  DynamicCodingKey.swift
//  Models
//
//  Created by Oleh Rozkvas on 11.03.2026.
//

public struct DynamicCodingKey: CodingKey {

    public var stringValue: String
    public var intValue: Int? { nil }

    public init(_ string: String) {
        self.stringValue = string
    }

    public init?(stringValue: String) {
        self.stringValue = stringValue
    }

    public init?(intValue: Int) {
        return nil
    }
}
