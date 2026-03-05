//
//  CollapsingHeaderScrollView.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 10.02.2026.
//

import SwiftUI
import DesignSystem

struct CollapsingHeaderView<Content: View>: View {
    @Environment(\.theme) private var theme
    let title: LocalizedStringResource
    let content: () -> Content

    @State private var headerVisible: Bool = true
    @State private var scrollOffset: CGFloat = 0

    init(title: LocalizedStringResource, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                ScrollView {
                    VStack(spacing: 0) {
                        Text(title)
                            .font(theme.typography.largeTitle)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .background(
                                GeometryReader { geo in
                                    Color.clear
                                        .preference(key: HeaderMinYPreferenceKey.self, value: geo.frame(in: .named("scroll")).minY)
                                }
                            )
                            .onPreferenceChange(HeaderMinYPreferenceKey.self) { minY in
                                self.scrollOffset = minY
                                self.headerVisible = minY > -proxy.safeAreaInsets.top
                            }
                            .opacity(headerVisible ? 1 : 0)
                            .frame(height: 56)
                        content()
                    }
                }
                .coordinateSpace(name: "scroll")

                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: theme.colors.appBackground.opacity(0.9), location: 0),
                        .init(color: theme.colors.appBackground.opacity(0.8), location: 1)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .opacity(headerVisible ? 0 : 1)
                .animation(.easeInOut(duration: 0.2), value: headerVisible)
                .frame(height: proxy.safeAreaInsets.top)
                .ignoresSafeArea(edges: .top)

                Text(title)
                    .font(theme.typography.sectionTitle)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: theme.colors.appBackground.opacity(0.8), location: 0),
                                .init(color: theme.colors.appBackground.opacity(0.6), location: 0.8),
                                .init(color: theme.colors.appBackground.opacity(0), location: 1)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                    .opacity(headerVisible ? 0 : 1)
                    .animation(.easeInOut(duration: 0.2), value: headerVisible)
            }
        }
    }
}
private struct HeaderMinYPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

