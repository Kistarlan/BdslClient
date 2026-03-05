//
//  NumbersOnlyModifier.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 10.03.2026.
//

import SwiftUI

struct NumbersOnlyModifier: ViewModifier {
    @Binding var text: String
    let maxLength: Int?

    func body(content: Content) -> some View {
        content
            .onChange(of: text) { _, newValue in
                var filtered = newValue.filter(\.isNumber)

                if let maxLength {
                    filtered = String(filtered.prefix(maxLength))
                }

                if filtered != newValue {
                    text = filtered
                }
            }
    }
}

extension View {
    func numbersOnly(
        text: Binding<String>,
        maxLength: Int? = nil
    ) -> some View {
        modifier(NumbersOnlyModifier(
            text: text,
            maxLength: maxLength
        ))
    }
}
