//
//  NotificationLeadTime.swift
//  Models
//
//  Created by Oleh Rozkvas on 25.03.2026.
//

public enum NotificationLeadTime: Equatable, Sendable, Hashable, Codable {
    case disabled
    case preset(Int)

    public static let presets: [NotificationLeadTime] = [
        .preset(1),
        .preset(2),
        .preset(4),
        .preset(8)
    ]

    case custom(Int) // 1...24
}

public extension NotificationLeadTime {
    var seconds: Int {
        switch self {
        case .disabled: return 0
        case .preset(let hours), .custom(let hours): return hours * 60 * 60
        }
    }
}
