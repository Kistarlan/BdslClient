//
//  APIClient.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 23.01.2026.
//

import Foundation
import Models

protocol APIClient: Sendable {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
    func request(_ endpoint: Endpoint) async throws
    func ensureValidToken() async throws -> String?
}
