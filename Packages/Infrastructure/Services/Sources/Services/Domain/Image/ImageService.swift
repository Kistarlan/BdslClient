//
//  ImageService.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 25.02.2026.
//

import Foundation
import Models

public protocol ImageService : CacheableService, UserCacheableService {
    func fetchImage(_ uri: String) async throws -> Data
    func uploadImage(_ data: Data) async throws -> Avatar
}
