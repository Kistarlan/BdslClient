//
//  NetworkMonitorDelegate.swift
//  Services
//
//  Created by Oleh Rozkvas on 24.03.2026.
//

public protocol NetworkMonitorDelegate: AnyObject {
    func networkMonitor(_ monitor: NetworkMonitor, didChangeConnection isConnected: Bool)
}
