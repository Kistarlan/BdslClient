//
//  AppContainer.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 23.01.2026.
//

import Foundation
import OSLog
import Services
import SwiftUI
#if DEBUG
    import PreviewServices
#endif

final class AppContainer {
    static let shared: AppContainer = {
        #if DEBUG
            return AppContainer(services: AppServices.shared)
        #else
            return AppContainer(services: AppServices.shared)
        #endif
    }()

    let services: AppServices
    let appState: AppState
    let viewModelsFactory: ViewModelsFactory

    init(services: AppServices) {
        self.services = services

        appState = AppState(
            authRepository: services.authRepository,
            usersService: services.usersService,
            cachingManager: services.cachingManager,
            networkState: NetworkState(monitor: NetworkMonitor()),
            appSettings: services.appSettings,
            notificationManager: services.notificationManager
        )

        viewModelsFactory = ViewModelsFactory(appServices: services, appState: appState)
    }
}
