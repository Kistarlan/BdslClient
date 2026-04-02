//
//  ThemePickerView.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 09.02.2026.
//

import DesignSystem
import Models
import SwiftUI

struct ThemePickerView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @Environment(\.theme) private var theme

    private var colors: DSColors {
        theme.colors
    }

    var body: some View {
        ZStack {
            BackgroundView()

            List {
                ForEach(ThemeMode.allCases) { themeMode in
                    themeRow(themeMode)
                }
            }
            .listStyle(.insetGrouped)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(.theme)
                        .font(theme.typography.screenTitle)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .background(colors.appBackground)
            .scrollContentBackground(.hidden)
        }
        .toolbar(.hidden, for: .tabBar)
    }

    private func themeRow(_ themeMode: ThemeMode) -> some View {
        Button {
            appState.themeMode = themeMode
        } label: {
            HStack {
                Image(systemName: themeMode.systemIcon)
                    .frame(width: 24)

                Text(themeMode.displayName)
                    .foregroundStyle(colors.textPrimary)

                Spacer()

                if appState.themeMode == themeMode {
                    Image(systemName: "checkmark")
                        .foregroundStyle(colors.accent)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ZStack {
            ThemePickerView()
        }
    }
    .setupPreviewEnvironments(.light)
}
