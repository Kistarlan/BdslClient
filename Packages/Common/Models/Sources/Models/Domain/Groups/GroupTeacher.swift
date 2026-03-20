//
//  GroupTeacher.swift
//  Models
//
//  Created by Oleh Rozkvas on 19.03.2026.
//

public struct GroupTeacher: Identifiable, Hashable, Sendable {
    public let id: String
    public let name: String
    public let surname: String
    public let fullName: String

    public init(
        id: String,
        name: String,
        surname: String,
        fullName: String
    ) {
        self.id = id
        self.name = name
        self.surname = surname
        self.fullName = fullName
    }
}
