//
//  PreviewTeachersRepository.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 25.02.2026.
//

import Models
import Services

final class PreviewTeachersRepository: TeachersRepository {
    let previewDataProvider: PreviewDataProvider

    init(previewDataProvider: PreviewDataProvider) {
        self.previewDataProvider = previewDataProvider
    }

    func fetchTeachers() async throws -> [TeacherDTO] {
        let teachersDtos = try previewDataProvider.load([TeacherDTO].self, from: "Teachers")

        return teachersDtos
    }
}
