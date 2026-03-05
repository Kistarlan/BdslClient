//
//  SplashView.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 23.01.2026.
//

import SwiftUI
import DesignSystem

struct SplashView: View {
    @EnvironmentObject private var appState: AppState
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
