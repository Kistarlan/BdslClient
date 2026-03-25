//
//  TaskExtensions.swift
//  Models
//
//  Created by Oleh Rozkvas on 24.03.2026.
//

public enum TaskError: Error {
    case timeout
}

public func fetchWithNetworkCheck<T: Sendable>(
    _ duration: Duration,
    operation: @escaping @Sendable () async throws -> T
) async throws -> T {
    return try await withThrowingTaskGroup(of: T.self) { group in
        group.addTask {
            try await operation()
        }

        group.addTask {
            try await ContinuousClock().sleep(for: duration)
            throw TaskError.timeout
        }

        let result = try await group.next()!
        group.cancelAll()
        return result
    }
}
