//
//  PreviewImageRepository.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 25.02.2026.
//

import Foundation
import UIKit
import Models
import Services

final class PreviewImageRepository: ImageRepository {
    private let cache = Cache<String, Data>()

    func fetchImage(_ uri: String) async throws -> Data {
        if let cachedData = await cache[uri] {
            return cachedData as Data
        }

        let image = UIImage(systemName: "photo.fill")!
        let data = image.jpegData(compressionQuality: 0.8)!

        await cache.add(key: uri, value: data)

        return data
    }

    func uploadImage(_ data: Data) async throws -> AvatarDTO {
        let cacheKey = NSString(string: UUID().uuidString)
        await cache.add(key: String(cacheKey), value: data)

        let avatarDTO = AvatarDTO.previewValue(
            id: String(cacheKey),
            small: String(cacheKey),
            medium: String(cacheKey),
            large: String(cacheKey)
        )

        return avatarDTO
    }
}
