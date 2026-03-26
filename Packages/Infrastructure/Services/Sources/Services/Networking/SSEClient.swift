//
//  SSEClient.swift
//  Services
//
//  Created by Oleh Rozkvas on 08.03.2026.
//

import Foundation

final class SSEClient: Sendable {
    func stream(from url: URL) -> AsyncThrowingStream<String, Error> {
        AsyncThrowingStream { continuation in
            let task = Task {
                do {
                    let (bytes, response) = try await URLSession.shared.bytes(from: url)

                    guard let http = response as? HTTPURLResponse,
                          (200 ..< 300).contains(http.statusCode)
                    else {
                        throw URLError(.badServerResponse)
                    }

                    for try await line in bytes.lines {
                        continuation.yield(line)
                    }

                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }

            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }

    func events<T: Decodable & Sendable>(
        from url: URL,
        as type: T.Type
    ) -> AsyncThrowingStream<T, Error> {
        AsyncThrowingStream { continuation in
            let task = Task {
                do {
                    for try await line in stream(from: url) {
                        guard line.starts(with: "data:") else { continue }

                        let json = line.dropFirst(5)
                        let data = Data(json.utf8)

                        let event = try JSONDecoder().decode(T.self, from: data)

                        continuation.yield(event)
                    }

                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }

            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
