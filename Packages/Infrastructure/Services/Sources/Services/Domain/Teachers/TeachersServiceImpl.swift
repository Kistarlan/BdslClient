//
//  TeachersServiceImpl.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 25.02.2026.
//

import Foundation
import Models
import OSLog

final class TeachersServiceImpl : TeachersService {
    private let cache = Cache<String, TeacherModel>()
    private let logger = Logger.forCategory(String(describing: TeachersServiceImpl.self))

    private let teacherRepository: TeachersRepository
    private let usersService: UsersService

    init(teacherRepository: TeachersRepository,
         usersService: UsersService) {
        self.teacherRepository = teacherRepository
        self.usersService = usersService
    }

    func fetchTeacher(for id: String) async throws -> TeacherModel {
        let teachers = try await fetchTeachers(forceReload: false)

        if let teacher = teachers.first(where: { $0.id == id }) {
            return teacher
        } else {
            throw TeachersServiceError.teacherNotFound(id)
        }
    }

    func fetchTeachers(forceReload: Bool) async throws -> [TeacherModel] {
        if forceReload {
            await clearCache()
        } else {
            let isEmpty = await cache.isEmpty

            if !isEmpty {
                return await cache.getAll()
            }
        }

        let dtos = try await teacherRepository.fetchTeachers()
        let users = try await usersService.fetchUsersInfo(for: dtos.map(\.userId))

        var models: [TeacherModel] = []

        for dto in dtos {
            do {
                try Task.checkCancellation()

                guard let userInfo = users.first(where: {$0.id == dto.userId}) else {
                    continue
                }

                let teacherModel = TeacherModel(
                    id: dto.id,
                    active: dto.active,
                    activityIds: dto.activityIds,
                    user: userInfo,
                    about: dto.about
                )

                models.append(teacherModel)
                await cache.add(key: teacherModel.id, value: teacherModel)
            } catch is CancellationError {
                logger.warning("Cancelled while fetching teachers")
            }

        }

        return await cache.getAll()
    }

    func clearCache() async {
        await cache.clear()
    }
}

private enum TeachersServiceError: Error {
    case teacherNotFound(String)
}
