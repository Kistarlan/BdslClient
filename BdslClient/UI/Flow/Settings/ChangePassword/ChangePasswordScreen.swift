//
//  ChangePasswordScreen.swift
//  BdslClient
//

import DesignSystem
import Models
import Navigation
import SwiftUI

struct ChangePasswordScreen: View {
    @Environment(\.theme) private var theme
    @State private var viewModel: ChangePasswordViewModel

    init(viewModel: ChangePasswordViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            BackgroundView()
                .ignoresSafeArea()

            if viewModel.isSuccess {
                ChangePasswordSuccessView()
            } else {
                ChangePasswordFormView(viewModel: viewModel, onSubmit: changePassword)
            }
        }
        .navigationTitle(Text(LocalizedStringResource.changePassword))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }

    private func changePassword() {
        Task { await viewModel.changePassword() }
    }
}

#Preview {
    let router: Router = .previewRouter()
    NavigationContainer(parentRouter: router) {
        ChangePasswordScreen(viewModel: AppContainer.shared.viewModelsFactory.makeChangePasswordViewModel())
    }
    .setupPreviewEnvironments(.light, router)
}
