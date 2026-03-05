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

//extension Tab {
//    @available(iOS, introduced: 16.0, deprecated: 26.0, message: "In iOS it is already integrated")
//    init<T>(
//        _ titleResource: LocalizedStringResource,
//        systemImage: String,
//        value: T,
//        @ViewBuilder content: () -> Content
//    ) where Value == T?, Label == DefaultTabLabel, T : Hashable{
//        self.init(LocalizedStringKey(resource.key), systemImage: systemImage, value: value, content: content)
//    }
//}
