//
//  Credentials.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 23.01.2026.
//

public enum Credentials: Sendable {
    case telegram(phone: String)
    case phonePassword(phone: String, password: String)
    case oauth(accessToken: String)
}

extension Credentials: Encodable {

    enum CodingKeys: String, CodingKey {
        case method
        case login
        case type
        case password
        case accessToken
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {

        case let .telegram(phone):
            try container.encode("phone", forKey: .method)
            try container.encode(phone, forKey: .login)
            try container.encode("telegramBot", forKey: .type)
            try container.encode("", forKey: .password)

        case let .phonePassword(phone, password):
            try container.encode("phone", forKey: .method)
            try container.encode(phone, forKey: .login)
            try container.encode("password", forKey: .type)
            try container.encode(password, forKey: .password)

        case let .oauth(token):
            try container.encode("oauth", forKey: .method)
            try container.encode(token, forKey: .accessToken)
        }
    }
}
