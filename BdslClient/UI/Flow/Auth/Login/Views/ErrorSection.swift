//
//  ErrorSection.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 02.04.2026.
//

import SwiftUI
import DesignSystem

struct ErrorSection: View {
    @Environment(\.theme) private var theme
    let error: LocalizedStringResource

    var body: some View {
        Text(error)
            .foregroundStyle(.red)
            .font(theme.typography.secondary)
    }
}
