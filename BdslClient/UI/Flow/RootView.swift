//
//  RootView.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 23.01.2026.
//
import Models
import Navigation
import OSLog
import SwiftUI

struct RootView: View {
    @EnvironmentObject private var appState: AppState
    @State private var mainVM: MainViewModel = AppContainer.shared.viewModelsFactory.makeMainViewModel()
    @State var router: Router = .init(level: 0, identifierDestination: nil)

    var body: some View {
        return Group {
            switch appState.state {
            case .splash:
                SplashView()

            case .authenticated, .unauthenticated:
                MainTabView(router: router, mainViewModel: mainVM)
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
