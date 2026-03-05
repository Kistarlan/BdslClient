//
//  JwtDecodingError.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 26.01.2026.
//

public enum JwtDecodingError: Error {
    case invalidFormat
    case invalidBase64
    case invalidJSON
}
