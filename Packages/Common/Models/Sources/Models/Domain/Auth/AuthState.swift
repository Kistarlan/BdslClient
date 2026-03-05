//
//  AuthState.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 23.01.2026.
//

public enum AuthState: Equatable, Sendable {
    case undefined
    case unauthenticated
    case authenticated(User)
    case expired
}
