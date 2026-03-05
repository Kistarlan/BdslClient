//
//  TeachersRepository.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 25.02.2026.
//

import Models

public protocol TeachersRepository: Sendable {
    func fetchTeachers() async throws -> [TeacherDTO]
}
