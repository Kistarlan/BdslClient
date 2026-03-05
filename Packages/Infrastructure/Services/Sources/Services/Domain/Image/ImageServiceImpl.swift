//
//  ImageServiceImpl.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 25.02.2026.
//

import Foundation
import Models

final class ImageServiceImpl : ImageService {
    private let cache = Cache<String, Data>()
    private let imageRepository: ImageRepository

    init(imageRepository: ImageRepository) {
        self.imageRepository = imageRepository
    }

    func fetchImage(_ uri: String) async throws -> Data {
        if let cachedData = await cache.get(key: uri) {
            return cachedData as Data
        }

        let imageData: Data = try await imageRepository.fetchImage(uri)

        await cache.add(key: uri, value: imageData)

        return imageData
    }

    func uploadImage(_ data: Data) async throws -> Avatar {
        let avatarDTO: AvatarDTO = try await imageRepository.uploadImage(data)

        return avatarDTO.toDomain()
    }

    func clearCache() async {
        await cache.clear()
    }

    func clearUserCache() async {
        await clearCache()
    }
}
