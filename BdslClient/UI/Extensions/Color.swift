//
//  Color.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 20.02.2026.
//

import SwiftUI

extension Color {
    init(hex: String) {
        var hex = hex
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")

        if hex.count == 3 {
            hex = hex.map { "\($0)\($0)" }.joined()
        }

        let scanner = Scanner(string: hex)
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255

        self.init(red: r, green: g, blue: b)
    }
}
