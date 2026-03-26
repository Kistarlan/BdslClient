//
//  StringExtensions.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 24.02.2026.
//

import Foundation

public extension String {
    func caseInsensitiveContains(_ other: String) -> Bool {
        return range(of: other, options: .caseInsensitive) != nil
    }

    var nilIfEmpty: String? {
        isEmpty ? nil : self
    }

    var isValidPhone: Bool {
        count == 10 &&
            first == "0" &&
            allSatisfy(\.isNumber)
    }
}

public extension LocalizedStringResource {
    var localized: String {
        String(localized: self)
    }

    func localized(locale: Locale) -> String {
        var localized = self
        localized.locale = locale
        return String(localized: localized)
    }
}
