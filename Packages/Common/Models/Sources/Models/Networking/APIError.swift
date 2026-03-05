//
//  APIError.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 23.01.2026.
//

public enum APIError: Error {
    case http(Int)
    case decoding
    case unauthorized
    case incorrectRefreshToken
}
