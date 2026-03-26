//
//  NetworkState.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 24.03.2026.
//

import Combine
import Services
import SwiftUI

@MainActor
final class NetworkState: ObservableObject, NetworkMonitorDelegate {
    @Published private(set) var isConnected: Bool = true

    private let monitor: NetworkMonitor

    init(monitor: NetworkMonitor) {
        self.monitor = monitor

        monitor.setObserver(self)
        isConnected = monitor.isConnected
    }

    func networkMonitor(_ monitor: NetworkMonitor, didChangeConnection isConnected: Bool) {
        self.isConnected = isConnected
    }
}
