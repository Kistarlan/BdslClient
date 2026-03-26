//
//  ThemeMode.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 09.02.2026.
//

public enum ThemeMode: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    public var id: String { rawValue }

    public var systemIcon: String {
        switch self {
        case .system:
            return "circle.lefthalf.filled"
        case .light:
            return "sun.max.circle"
        case .dark:
            return "moon.circle"
        }
    }
}
