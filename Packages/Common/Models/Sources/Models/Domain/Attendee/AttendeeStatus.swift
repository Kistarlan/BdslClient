//
//  AttendeeStatus.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 20.02.2026.
//

import Foundation

public enum AttendeeStatus: String, Decodable, Sendable {
    case confirmed
    case suggested
}
