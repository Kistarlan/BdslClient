//
//  DismissButtonModifier.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 02.02.2026.
//

import SwiftUI

public struct DismissButtonModifier: ViewModifier {
    let title: LocalizedStringResource
    @Environment(\.dismiss) var dismiss

    public func body(content: Content) -> some View {
        content.toolbar {
            Button(action: { dismiss() }) {
                Text(title)
            }
        }
    }
}

public extension View {
    func addDismissButton(_ title: LocalizedStringResource) -> some View {
        modifier(DismissButtonModifier(title: title))
    }
}
