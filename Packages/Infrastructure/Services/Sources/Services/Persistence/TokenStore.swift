//
//  TokenStore.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 23.01.2026.
//
import Models

public protocol TokenStore: Sendable {
    func save(tokenType: TokenType, token: String) async
    func load(tokenType: TokenType) async -> String?
    func clear(tokenType: TokenType) async
    func clearAll() async
}
