//
//  KeychainTokenStore.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 23.01.2026.
//

import Foundation
import Models
import OSLog
import Security

public final class KeychainTokenStore: TokenStore {
    private let service: String

    public init(service: String) {
        self.service = service
    }

    // MARK: - Save token

    public func save(tokenType: TokenType, token: String) async {
        let deleteQuery: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: tokenType.rawValue
        ]
        SecItemDelete(deleteQuery as CFDictionary)

        // Перетворюємо на Data
        guard let data = token.data(using: .utf8) else { return }

        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: tokenType.rawValue,
            kSecValueData: data,
            kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            print("Keychain save failed with status: \(status)")
        }
    }

    // MARK: - Load token

    public func load(tokenType: TokenType) async -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: tokenType.rawValue,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ]

        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status == errSecSuccess,
              let data = item as? Data,
              let token = String(data: data, encoding: .utf8)
        else {
            return nil
        }

        return token
    }

    // MARK: - Clear specific token

    public func clear(tokenType: TokenType) async {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: tokenType.rawValue
        ]
        SecItemDelete(query as CFDictionary)
    }

    // MARK: - Clear all tokens for this service

    public func clearAll() async {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service
        ]
        SecItemDelete(query as CFDictionary)
    }
}
