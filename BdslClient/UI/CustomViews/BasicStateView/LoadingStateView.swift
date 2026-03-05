//
//  LoadingStateView.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 03.02.2026.
//
import SwiftUI
import DesignSystem

public struct LoadingStateView: View {
    @Environment(\.theme) private var theme
    @State var showProgress: Bool
    @State var title: String

    public init(showProgress: Bool = false, title: String = "Loading...") {
        self.showProgress = showProgress
        self.title = title
    }

    public var body: some View {
        VStack {
            if showProgress {
                VStack(spacing: theme.layout.spacing.sm) {
                    ProgressView()
                    Text(title)
                        .foregroundStyle(.secondary)
                }
                .padding(theme.layout.spacing.s)
            } else {
                Color.clear
                    .frame(width: 100, height: 80)
            }
        }
        .frame(minWidth: 100, minHeight: 80)
        .task { await toggleProgress() }
    }

    func toggleProgress() async {
        guard !showProgress else { return }

        do {
            try await Task.sleep(for: .seconds(1))
            withAnimation { showProgress.toggle() }
        } catch {}
    }
}

#Preview {
    VStack {
        LoadingStateView()
            .border(Color.red)

        LoadingStateView(showProgress: true)
            .border(Color.blue)
    }
}
