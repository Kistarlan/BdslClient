//
//  DateExtensions.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 26.02.2026.
//

import Foundation

extension Date {
    var appShortDate: String {
        formatted(date: .abbreviated, time: .omitted)
    }
}
