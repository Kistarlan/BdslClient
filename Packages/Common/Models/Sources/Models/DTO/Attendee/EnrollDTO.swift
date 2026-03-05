//
//  EnrollDTO.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 20.02.2026.
//

import Foundation

public struct EnrollDTO: Decodable {
    public let id: String
    public let userSubscriptionId: String
    public let time: Date

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userSubscriptionId = "userSubscription"
        case time
    }
}
