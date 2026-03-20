//
//  AvatarData.swift
//  Models
//
//  Created by Oleh Rozkvas on 19.03.2026.
//

import Foundation

public struct AvatarData: Identifiable, Hashable, Sendable {
    public let id: String
    public let data: Data

    public init(
        id: String,
        data: Data,
    ) {
        self.id = id
        self.data = data
    }
}
