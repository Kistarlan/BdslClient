//
//  ResetPasswordChannel.swift
//  Models
//
//  Created by Oleh Rozkvas on 13.04.2026.
//

public enum ResetPasswordChannel: String, Codable, Sendable {
    case telegramBot
    case phone
    case debugLog
}
