//
//  JwtDecoderImpl.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 26.01.2026.
//

import Foundation
import Models

public final class JwtDecoderImpl: JwtDecoder {

    public init() {}

    public func decode<T: Decodable>(_ token: String, as type: T.Type) throws -> T {
        let parts = token.split(separator: ".", omittingEmptySubsequences: false)

        guard parts.count == 3 else {
            throw JwtDecodingError.invalidFormat
        }

        let payloadPart = String(parts[1])

        guard let payloadData = base64UrlDecode(payloadPart) else {
            throw JwtDecodingError.invalidBase64
        }

        do {
            return try JSONDecoder().decode(T.self, from: payloadData)
        } catch {
            throw JwtDecodingError.invalidJSON
        }
    }

    public func encode<T: Encodable>(_ payload: T) throws -> String {
        let header: [String: String] = [
            "alg": "none",
            "typ": "JWT"
        ]

        let headerData = try JSONSerialization.data(withJSONObject: header)
        let payloadData = try JSONEncoder().encode(payload)

        let headerBase64 = base64UrlEncode(headerData)
        let payloadBase64 = base64UrlEncode(payloadData)

        return "\(headerBase64).\(payloadBase64).preview"
    }

    // MARK: - Base64URL helpers

    private func base64UrlEncode(_ data: Data) -> String {
        data.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }

    private func base64UrlDecode(_ value: String) -> Data? {
        var base64 = value
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")

        let remainder = base64.count % 4
        if remainder > 0 {
            base64.append(String(repeating: "=", count: 4 - remainder))
        }

        return Data(base64Encoded: base64)
    }
}
