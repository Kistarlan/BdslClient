//
//  RootView.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 23.01.2026.
//
import OSLog
import SwiftUI
import Models
import Navigation

struct RootView: View {
    @EnvironmentObject private var appState: AppState
    @State private var loginVM: LoginViewModel = AppContainer.shared.viewModelsFactory.makeLoginViewModel()
    @State private var mainVM: MainTabViewModel = AppContainer.shared.viewModelsFactory.makeMainTabViewModel()
    @State var router: Router = .init(level: 0, identifierDestination: nil)

    var body: some View {
        return Group {
            switch appState.state {
            case .splash:
                SplashView()

            case .unauthenticated:
                LoginScreen(loginVM)

            case .authenticated:
                MainTabView(router: router, mainTabViewModel: mainVM)
            }
        }
        .onAppear {
            Logger.current().debug("Root View appeared")
        }
        .task {
            appState.bootstrap()
        }
    }
}

#Preview {
    RootView()
        .setupPreviewEnvironments()
}
