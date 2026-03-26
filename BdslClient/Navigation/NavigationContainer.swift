//
//  NavigationContainer.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 27.01.2026.
//

import Navigation
import OSLog
import SwiftUI

/// ``NavigationStack`` container that works with the ``Router``
/// to resolve the routes based on the ``Router``'s state
struct NavigationContainer<Content: View>: View {
    // The navigation container itself it's in charge of the lifecycle
    // of the router.
    @State var router: Router
    @ViewBuilder var content: () -> Content

    init(
        parentRouter: Router,
        destination: Destination? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        if let dest = destination {
            _router = .init(initialValue: parentRouter.childRouter(for: dest))
        } else {
            _router = .init(initialValue: parentRouter)
        }

        self.content = content
    }

    var body: some View {
        InnerContainer(router: router) {
            content()
        }
        .environment(router)
        .onAppear(perform: router.setActive)
        .onDisappear(perform: router.resignActive)
    }
}

private struct InnerContainer<Content: View>: View {
    @Bindable var router: Router
    @ViewBuilder var content: () -> Content

    var body: some View {
        NavigationStack(path: $router.navigationStackPath) {
            content()
                .navigationDestination(for: PushDestination.self) { destination in
                    view(for: destination)
                }
        }
        .sheet(item: $router.presentingSheet) { sheet in
            navigationView(for: sheet, from: router)
        }
        .fullScreenCover(item: $router.presentingFullScreen) { fullScreen in
            navigationView(for: fullScreen, from: router)
        }
    }

    @ViewBuilder func navigationView(for destination: SheetDestination, from router: Router) -> some View {
        NavigationContainer(parentRouter: router, destination: Destination.sheet(destination)) { view(for: destination)
        }
    }

    @ViewBuilder func navigationView(for destination: FullScreenDestination, from router: Router) -> some View {
        NavigationContainer(parentRouter: router, destination: Destination.fullScreen(destination)) {
            view(for: destination)
        }
    }
}

#Preview {
    NavigationContainer(parentRouter: .previewRouter()) {
        Text("Hello")
    }
}
