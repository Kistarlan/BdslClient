//
//  PasswordResetResponseModel.swift
//  Models
//
//  Created by Oleh Rozkvas on 13.04.2026.
//

public struct PasswordResetResponseModel : Decodable {
    public let id: String
    public let contacts: ContactDTO
}
