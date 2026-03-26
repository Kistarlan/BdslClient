//
//  EnvironmentValues.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 06.02.2026.
//

import DesignSystem
import SwiftUI

private struct ThemeKey: EnvironmentKey {
    @MainActor static let defaultValue: AppTheme = DarkTheme()
}

extension EnvironmentValues {
    var theme: AppTheme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}
