//
//  LoginBackgroundView.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 05.02.2026.
//

import DesignSystem
import Models
import SwiftUI

struct LoginBackgroundView: View {
    @Environment(\.theme) private var theme
    @Environment(AppState.self) private var appState

    var body: some View {
        theme.colors.loginBackground
            .overlay(getOverlayGradient())
            .ignoresSafeArea()
    }

    private func getOverlayGradient() -> LinearGradient {
        return LinearGradient(
            stops: [
                Gradient.Stop(color: .white.opacity(0.1), location: 0),
                Gradient.Stop(color: .clear, location: 0.6),
                Gradient.Stop(color: .black.opacity(0.5), location: 1)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

#Preview {
    LoginBackgroundView()
        .setupPreviewEnvironments(.dark)
}
