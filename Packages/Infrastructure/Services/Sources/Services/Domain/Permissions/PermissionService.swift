//
//  PermissionService.swift
//  Services
//
//  Created by Oleh Rozkvas on 30.03.2026.
//

@MainActor
public protocol PermissionService {
    func requestNotificationPermission() async -> Bool
    func isNotificationPermissionGranted() async -> Bool
    func openSettings()
}
