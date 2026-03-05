//
//  RoundedBorder.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 24.02.2026.
//

import SwiftUI

extension View {
    func roundedBorder(
        radius: CGFloat,
        corners: UIRectCorner = .allCorners,
        borderColor: Color,
        lineWidth: CGFloat = 1
    ) -> some View {
        self
            .clipShape(RoundedCorner(radius: radius, corners: corners))
            .overlay(
                RoundedCorner(radius: radius, corners: corners)
                    .stroke(borderColor, lineWidth: lineWidth)
            )
    }
}
