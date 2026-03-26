//
//  PreviewDataService.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 04.02.2026.
//

import Foundation

final class PreviewDataService: PreviewDataProvider {
    func load<T: Decodable>(_ type: T.Type, from file: String) throws -> T {
        if let url = Bundle.module.url(forResource: file, withExtension: "json") {
            do {
                let data = try! Data(contentsOf: url)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                return try decoder.decode(T.self, from: data)
            } catch {
                print(error.localizedDescription)
                throw error
            }
        } else {
            throw PreviewDataError.fileNotFound
        }
    }
}

private enum PreviewDataError: Error {
    case fileNotFound
}
