//
//  BdslClientApp.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 23.01.2026.
//

import Models
import SwiftUI

@main
struct BdslClientApp: App {
    @Environment(\.colorScheme) private var systemScheme
    @State private var appState = AppContainer.shared.appState

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(
                    \.theme,
                    appState.resolveTheme(systemScheme: systemScheme)
                )
                .preferredColorScheme(
                    appState.themeMode == .system
                        ? systemScheme
                        : (appState.themeMode == .dark ? .dark : .light)
                )
                .environment(\.locale, resolvedLocale)
                .environment(appState)
        }
    }

    private var resolvedLocale: Locale {
        appState.appLanguage.locale ?? .current
    }
}
