//
//  SplashView.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 23.01.2026.
//

import DesignSystem
import SwiftUI

struct SplashView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.theme) private var theme

    var body: some View {
        ZStack {
            LoginBackgroundView()
            Image(.appLogo)
                .resizable()
                .scaledToFit()
                .foregroundStyle(.white)
                .padding(.all, theme.layout.spacing.xxl)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SplashView()
        .setupPreviewEnvironments()
}
