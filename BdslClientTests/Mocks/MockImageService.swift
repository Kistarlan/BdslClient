//
//  MockImageService.swift
//  BdslClientTests
//

import Foundation
import Models
import Services

final class MockImageService: ImageService, @unchecked Sendable {
    func fetchImage(_ uri: String) async throws -> Data { Data() }
    func uploadImage(_ data: Data) async throws -> Avatar {
        Avatar(id: "avatar-1", small: "", medium: "", large: "")
    }
    func clearCache() async {}
    func clearUserCache() async {}
}
