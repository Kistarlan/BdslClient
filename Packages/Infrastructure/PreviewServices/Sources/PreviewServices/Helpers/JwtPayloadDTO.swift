//
//  JwtPayloadDTO.swift
//  PreviewServices
//
//  Created by Oleh Rozkvas on 04.03.2026.
//

import Foundation
import Models

extension JwtPayloadDTO {
    static func previewValue(
        user: UserIdentifierDTO = UserIdentifierDTO.previewValue(),
        exp: TimeInterval = Date().addingTimeInterval(3600).timeIntervalSince1970
    ) -> Self {
        let json: [String: Any] = [
            "user": [
                "id": user.id,
                "fullName": user.fullName,
                "role": user.role
            ],
            "exp": exp
        ]
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        return try! JSONDecoder().decode(JwtPayloadDTO.self, from: data)
    }
}

extension UserIdentifierDTO {
    static func previewValue(
        id: String = "60243f19bec178115ef553f3",
        fullName: String = "Ростислав Одинець",
        role: String = "admin"
    ) -> Self {
        let json: [String: Any] = [
            "id": id,
            "fullName": fullName,
            "role": role
        ]
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        return try! JSONDecoder().decode(UserIdentifierDTO.self, from: data)
    }
}
