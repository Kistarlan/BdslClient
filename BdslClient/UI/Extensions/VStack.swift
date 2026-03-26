//
//  VStack.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 18.02.2026.
//

import DesignSystem
import SwiftUI

extension VStack {
    func applyGroupContainerStyle(_ theme: AppTheme) -> some View {
        background(theme.colors.cardBackground)
            .cornerRadius(theme.layout.cornerRadius.l)
    }
}
