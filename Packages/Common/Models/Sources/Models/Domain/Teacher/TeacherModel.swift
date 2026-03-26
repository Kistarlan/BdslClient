//
//  TeacherModel.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 25.02.2026.
//

public struct TeacherModel: Identifiable, Hashable, Sendable {
    public let id: String
    public let active: Bool
    public let activityIds: [String]
    public let user: User
    public let about: String?

    // MARK: - Public initializer

    public init(
        id: String,
        active: Bool,
        activityIds: [String],
        user: User,
        about: String?
    ) {
        self.id = id
        self.active = active
        self.activityIds = activityIds
        self.user = user
        self.about = about
    }
}
