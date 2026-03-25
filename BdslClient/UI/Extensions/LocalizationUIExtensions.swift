//
//  LocalizationUIExtensions.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 13.03.2026.
//

import SwiftUI

extension TextField where Label == Text {
    @available(iOS, introduced: 16.0, deprecated: 26.0, message: "In iOS it is already integrated")
    init(_ resource: LocalizedStringResource, text: Binding<String>) {
        self.init(LocalizedStringKey(resource.key), text: text)
    }
}
