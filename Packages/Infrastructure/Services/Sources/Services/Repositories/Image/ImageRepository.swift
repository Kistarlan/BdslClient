//
//  ImageRepository.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 18.02.2026.
//

import Foundation
import Models

public protocol ImageRepository: Sendable {
    func fetchImage(_ uri: String) async throws -> Data
    func uploadImage(_ data: Data) async throws -> AvatarDTO
}
