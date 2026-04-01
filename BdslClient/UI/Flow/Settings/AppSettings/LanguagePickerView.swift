//
//  LanguagePickerView.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 09.02.2026.
//

import DesignSystem
import Models
import SwiftUI

struct LanguagePickerView: View {
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
                ForEach(AppLanguage.allCases) { language in
                    languageRow(language)
                }
            }
            .listStyle(.insetGrouped)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(.language)
                        .font(theme.typography.screenTitle)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .background(colors.appBackground)
            .scrollContentBackground(.hidden)
        }
        .toolbar(.hidden, for: .tabBar)
    }

    private func languageRow(_ language: AppLanguage) -> some View {
        Button {
            appState.appLanguage = language
        } label: {
            HStack {
                Text(language.displayName)
                    .foregroundColor(colors.textPrimary)

                Spacer()

                if appState.appLanguage == language {
                    Image(systemName: "checkmark")
                        .foregroundColor(colors.accent)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ZStack {
            LanguagePickerView()
        }
    }
    .setupPreviewEnvironments(.light)
}
