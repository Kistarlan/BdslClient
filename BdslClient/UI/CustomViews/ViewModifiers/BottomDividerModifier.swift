//
//  BottomDividerModifier.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 31.03.2026.
//

import SwiftUI
import DesignSystem

struct BottomDividerModifier: ViewModifier {
    @Environment(\.theme) private var theme
    let edges: Edge.Set
    let length: CGFloat?

    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            content

            Divider()
                .background(theme.colors.divider)
                .frame(height: 1)
                .padding(edges, length ?? 0)
        }
    }
}

extension View {
    func bottomDivider(_ edges: Edge.Set = .all, _ length: CGFloat? = nil) -> some View {
        modifier(BottomDividerModifier(edges: edges, length: length))
    }
}
