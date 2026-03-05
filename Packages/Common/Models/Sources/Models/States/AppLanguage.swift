//
//  AppLanguage.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 09.02.2026.
//

import Foundation

public enum AppLanguage: String, CaseIterable, Identifiable {
    case system
    case en
    case ua

    public var id: String { rawValue }

    public var locale: Locale? {
        switch self {
        case .system:
            return nil // важливо
        case .en:
            return Locale(identifier: "en")
        case .ua:
            return Locale(identifier: "uk")
        }
    }
}
