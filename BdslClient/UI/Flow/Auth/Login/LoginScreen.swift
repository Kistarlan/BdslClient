//
//  LoginScreen.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 23.01.2026.
//

import DesignSystem
import Models
import Navigation
import SwiftUI

struct LoginScreen: View {
    @Environment(AppState.self) private var appState
    @Environment(Router.self) private var router
    @Environment(\.theme) private var theme
    @State private var viewModel: LoginViewModel

    init(_ loginViewModel: LoginViewModel) {
        _viewModel = State(wrappedValue: loginViewModel)
    }

    var body: some View {
        ZStack {
            LoginBackgroundView()
                .ignoresSafeArea()
            VStack(spacing: theme.layout.spacing.l) {
                Spacer()

                Image(.appLogo)
                    .resizable()
                    .scaledToFit()
                    .containerRelativeFrame(.vertical) { length, _ in
                        length / 4.0
                    }

                LoginSectionView(viewModel)

                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onDisappear {
            viewModel.reset()
        }
        .onChange(of: appState.state) {
            if appState.state.isAuthenticated {
                router.navigateToRoot()
            }
        }
    }
}



#Preview {
    NavigationStack {
        LoginScreen(AppContainer.shared.viewModelsFactory.makeLoginViewModel())
            .setupPreviewEnvironments(.light)
    }
}
