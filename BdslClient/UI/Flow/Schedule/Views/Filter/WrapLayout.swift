//
//  WrapLayout.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 03.03.2026.
//


import SwiftUI

struct WrapLayout<Content: View>: View {

    @ViewBuilder let content: Content

    var body: some View {
        FlowLayout {
            content
        }
    }
}