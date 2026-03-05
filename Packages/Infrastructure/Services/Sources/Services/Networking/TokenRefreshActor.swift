//
//  TokenRefreshActor.swift
//  Services
//
//  Created by Oleh Rozkvas on 11.03.2026.
//

actor TokenRefreshActor {
    private var refreshTask: Task<String, Error>?

    func token(using block: @Sendable @escaping () async throws -> String) async throws -> String {

        if let refreshTask {
            return try await refreshTask.value
        }

        let task = Task {
            try await block()
        }

        refreshTask = task

        defer { refreshTask = nil }

        return try await task.value
    }
}
