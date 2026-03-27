//
//  UpcomingClassesGenerating.swift
//  Services
//
//  Created by Oleh Rozkvas on 22.03.2026.
//

import Foundation
import Models

protocol UpcomingClassesGenerating: Sendable {
    func generate(
        from classes: [ClassModel],
        now: Date,
        horizon: TimeInterval
    ) -> [UpcomingClassModel]
}
