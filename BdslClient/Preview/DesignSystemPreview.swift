//
//  DesignSystemPreview.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 06.02.2026.
//

import SwiftUI
import Models
import DesignSystem
import Navigation

extension View {
    func setupPreviewEnvironments(_ themeMode: ThemeMode = .light, _ router: Router? = nil) -> some View {
        let container = AppContainer.shared
        let appState = container.appState
        appState.themeMode = themeMode

        return environment(
            \.theme,
            appState.resolveTheme(systemScheme: .light)
        )
        .environment(
            \.locale,
            appState.appLanguage.locale ?? .current
        )
        .environment(router ?? .previewRouter())
        .preferredColorScheme(themeMode == .dark ? .dark : .light)
        .environmentObject(appState)
    }
}
