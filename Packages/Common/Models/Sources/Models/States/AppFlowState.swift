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
