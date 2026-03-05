//
//  SettingsScreen.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 04.02.2026.
//

import SwiftUI
import Models
import Navigation

struct SettingsScreen: View {
    @Environment(\.locale) private var locale
    @Environment(\.theme) private var theme
    @State private var viewModel: SettingsViewModel
    @Environment(Router.self) private var router
    init(settingsViewModel: SettingsViewModel) {
        viewModel = settingsViewModel
    }

    var body: some View {
        ZStack {
            BackgroundView()
                .ignoresSafeArea()
            SettingsView(viewModel: viewModel)
        }
        .navigationTitle(Text(LocalizedStringResource.settings))
        .id(locale.identifier)
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            viewModel.onAppear()
        }
        .onChange(of: router.popResults) {
            if let currentUser = viewModel.user,
               let updatedUser: User = router.consumePopResult(for: .changeUserInfo(user: currentUser))
            {
                viewModel.updateUser(updatedUser)
            }
        }
    }
}

#Preview {
    let router: Router = .previewRouter()
    NavigationContainer(parentRouter: router) {
        ZStack {
            BackgroundView()
            SettingsScreen(settingsViewModel: AppContainer.shared.viewModelsFactory.makePreviewSettingsViewModel())
        }
    }
    .setupPreviewEnvironments(.light, router)
}
