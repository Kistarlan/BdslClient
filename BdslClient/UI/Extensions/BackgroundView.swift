//
//  BackgroundView.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 09.02.2026.
//

import DesignSystem
import Models
import SwiftUI

struct BackgroundView: View {
    @Environment(\.theme) private var theme
    @Environment(AppState.self) private var appState

    var body: some View {
        if appState.themeMode == .dark {
            return LinearGradient(
                colors: [
                    Color("0C0D10"),
                    Color("0F1114")
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        } else {
            return LinearGradient(
                colors: [
                    theme.colors.appBackground,
                    theme.colors.appBackground
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        }
    }
}

#Preview {
    BackgroundView()
        .setupPreviewEnvironments(.light)
}
