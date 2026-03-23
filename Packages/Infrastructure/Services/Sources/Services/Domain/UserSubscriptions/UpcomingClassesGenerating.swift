//
//  UpcomingClassesGenerating.swift
//  Services
//
//  Created by Oleh Rozkvas on 22.03.2026.
//

import Foundation
import Models

protocol UpcomingClassesGenerating {
    func generate(from classes: [ClassModel], now: Date) -> [UpcomingClassModel]
}
