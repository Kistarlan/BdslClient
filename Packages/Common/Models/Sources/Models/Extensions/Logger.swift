//
//  Logger.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 26.01.2026.
//

import OSLog

public extension Logger {
    static func forCategory(_ category: String) -> os.Logger {
        .init(subsystem: "org.ua.bdslviv.BdslClient", category: category)
    }

    static func current(
        fileID: String = #fileID
    ) -> Logger {
        forCategory(fileID)
    }
}
