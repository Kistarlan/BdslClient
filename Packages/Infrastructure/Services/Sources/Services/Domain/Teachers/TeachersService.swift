//
//  TeachersService.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 25.02.2026.
//

import Foundation
import Models

public protocol TeachersService: CacheableService {
    func fetchTeacher(for id: String) async throws -> TeacherModel
    func fetchTeachers(forceReload: Bool) async throws -> [TeacherModel]
}
