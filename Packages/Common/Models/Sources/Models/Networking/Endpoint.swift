//
//  Endpoint.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 23.01.2026.
//

import Foundation

public struct Endpoint: Sendable {
    public let path: String
    public let method: HTTPMethod
    public let headers: [String: String]
    public let query: [String: String]
    public let body: Data?

    public init(
        path: String,
        method: HTTPMethod,
        headers: [String: String] = [:],
        query: [String: String] = [:],
        body: Data? = nil
    ) {
        self.path = path
        self.method = method
        self.headers = headers
        self.query = query
        self.body = body
    }
}

public enum HTTPMethod: String, Sendable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}
