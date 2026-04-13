//
//  AuthRepositoryError.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 13.04.2026.
//


import Models

public enum AuthRepositoryError: Error {
    case notImplementedFor(Credentials)
    case sessionExpired
    case notImplemented(String)
}