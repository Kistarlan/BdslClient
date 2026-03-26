//
//  NotificationSettingsScreen.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 25.03.2026.
//

import SwiftUI
import Models
import DesignSystem
import Navigation

struct NotificationSettingsScreen: View {
    @Environment(\.locale) private var locale
    @Environment(\.theme) private var theme
    @Environment(Router.self) private var router
    @State private var viewModel: NotificationSettingsViewModel

    init(viewModel: NotificationSettingsViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ZStack {
            BackgroundView()
                .ignoresSafeArea()

            VStack(spacing: 0) {
                List {
                    Section {
                        offOption

                        presetOptions

                        custopOption
                    }
                    .background(theme.colors.cardBackground)
                }
                .scrollContentBackground(.hidden)

                Spacer()

                if viewModel.isCustom {
                    pickerView
                }
            }
        }
        .navigationTitle(Text(.notifications))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    saveAndPop()
                } label: {
                    Text("Save")
                }
                .disabled(!viewModel.isChanged)
            }
        }
    }

    private func saveAndPop() {
        viewModel.save()
        router.pop()
    }

    private var presetOptions: some View {
        ForEach(NotificationSettingsViewModel.presets, id: \.self) { preset in
            OptionRow(
                title: preset.displayName(locale: locale),
                isSelected: viewModel.selected == preset
            ) {
                viewModel.selectPreset(preset)
            }
        }
    }

    private var offOption: some View {
        OptionRow(
            title: LocalizedStringResource.off.localized(locale: locale),
            isSelected: viewModel.selected == .disabled
        ) {
            viewModel.disable()
        }
    }

    private var custopOption: some View {
        OptionRow(
            title: LocalizedStringResource.custom.localized(locale: locale),
            isSelected: viewModel.isCustom,
            value: customValueString
        ) {
            if !viewModel.isCustom {
                if case let .preset(value) = viewModel.selected{
                    viewModel.selectCustom(value)
                } else {
                    viewModel.selectCustom(1)
                }
            }
        }
    }

    private var pickerView: some View {
        Picker("", selection: Binding(
            get: {
                if case .custom(let value) = viewModel.selected {
                    return value
                }
                return 1
            },
            set: { viewModel.selectCustom($0) }
        )) {
            ForEach(1...24, id: \.self) { hour in
                Text(localizedHours(hour, locale: locale))
                    .tag(hour)
            }
        }
        .pickerStyle(.wheel)
        .frame(height: 180)
        .background(theme.colors.cardBackground)
    }

    private var customValueString: String? {
        if viewModel.isCustom {
            return viewModel.selected.displayName(locale: locale)
        }

        return nil
    }
}
