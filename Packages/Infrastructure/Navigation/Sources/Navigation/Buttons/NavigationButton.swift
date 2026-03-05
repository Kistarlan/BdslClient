//
//  NavigationButton.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 27.01.2026.
//

import SwiftUI

/// My own version of `NavigationLink` to work with the ``Router``
public struct NavigationButton<Content: View>: View {
    public let destination: Destination
    @ViewBuilder var content: () -> Content
    @Environment(Router.self) private var router

    public init(
        destination: Destination,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.destination = destination
        self.content = content
    }

    public init(
        push destination: PushDestination,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.destination = .push(destination)
        self.content = content
    }

    public init(
        sheet destination: SheetDestination,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.destination = .sheet(destination)
        self.content = content
    }

    public init(
        fullScreen destination: FullScreenDestination,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.destination = .fullScreen(destination)
        self.content = content
    }

    public var body: some View {
        Button {
            router.navigate(to: destination)
        } label: {
            content()
        }
    }
}
