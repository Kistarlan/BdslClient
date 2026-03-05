//
//  ShimmerModifier.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 11.03.2026.
//

import SwiftUI

public struct ShimmerModifier: ViewModifier {

    @State private var phase: CGFloat = -1
    let active: Bool

    public func body(content: Content) -> some View {
        content
            .overlay {
                if active {
                    GeometryReader { geometry in
                        let width = geometry.size.width

                        LinearGradient(
                            colors: [
                                .clear,
                                .white.opacity(0.4),
                                .clear
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(width: width * 1.5)
                        .rotationEffect(.degrees(20))
                        .offset(x: phase * width * 2)
                        .mask(content)
                    }
                    .allowsHitTesting(false)
                    .onAppear {
                        withAnimation(
                            .linear(duration: 1.2)
                            .repeatForever(autoreverses: false)
                        ) {
                            phase = 1
                        }
                    }
                }
            }
    }
}

public extension View {

    func shimmer(active: Bool) -> some View {
        modifier(ShimmerModifier(active: active))
    }
}
