//
//  NetworkMonitor.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 24.03.2026.
//

import Network
import SwiftUI

@Observable
@MainActor
public final class NetworkMonitor {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    public var isConnected: Bool = true

    // MARK: - Delegate

    private var delegate: NetworkMonitorDelegate?

    public init() {
        monitor.pathUpdateHandler = { path in
            Task { @MainActor in
                let connected = path.status == .satisfied
                if self.isConnected != connected {
                    self.isConnected = connected
                    if let delegate = self.delegate {
                        delegate.networkMonitor(self, didChangeConnection: connected)
                    }
                }
            }
        }
        monitor.start(queue: queue)
    }

    public func setObserver(_ delegate: NetworkMonitorDelegate) {
        self.delegate = delegate
    }
}
