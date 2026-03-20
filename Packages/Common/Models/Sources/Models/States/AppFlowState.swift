//
//  AppFlowState.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 09.02.2026.
//

public enum AppFlowState: Equatable {
    case splash
    case unauthenticated
    case authenticated(User)
}

public extension AppFlowState {
    var isAuthenticated: Bool {
        if case .authenticated = self {
            return true
        }
        return false
    }
}
