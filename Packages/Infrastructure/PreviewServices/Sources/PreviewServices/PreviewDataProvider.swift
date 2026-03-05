//
//  PreviewDataProvider.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 04.02.2026.
//

import Foundation

protocol PreviewDataProvider: Sendable {
    func load<T: Decodable>(_ type: T.Type, from file: String) throws -> T
}
