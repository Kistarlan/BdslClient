//
//  Destination.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 27.01.2026.
//

import Foundation
import Models

public enum Destination: Hashable {
    case tab(_ destination: TabDestination)
    case push(_ destination: PushDestination)
    case sheet(_ destination: SheetDestination)
    case fullScreen(_ destination: FullScreenDestination)
}

extension Destination: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .tab(destination): return ".tab(\(destination))"
        case let .push(destination): return ".push(\(destination))"
        case let .sheet(destination): return ".sheet(\(destination))"
        case let .fullScreen(destination): return ".fullScreen(\(destination))"
        }
    }
}

public enum TabDestination: String, Hashable {
    case subscription
    case myClasses
    case schedule
}

public enum PushDestination: Hashable, CustomStringConvertible {
    // MARK: - Auth

    case login
    case register
    case forgotPassword
    case resetPassword(inviteKey: ResetPasswordInviteKey)

    // MARK: - Settings

    case languageSettings
    case changeProfilePicture
    case changeUserInfo(user: User)
    case changePassword
    case themeSettings
    case profileInfo
    case notificationSettings

    // MARK: - Home

    case subsctiptionDetails(userSubscription: UserSubscription)
    case settings

    public var description: String {
        switch self {
        case .login: return ".login"
        case .register: return ".register"
        case .forgotPassword: return ".forgotPassword"
        case .languageSettings: return ".languageSettings"
        case .changeProfilePicture: return ".changeProfilePicture"
        case let .changeUserInfo(user): return ".changeUserInfo(\(user))"
        case .changePassword: return ".changePassword"
        case .themeSettings: return ".themeSettings"
        case let .subsctiptionDetails(userSubscription): return ".subsctiptionDetails(\(userSubscription.id))"
        case .profileInfo: return ".profileInfo"
        case .settings: return ".settings"
        case .notificationSettings: return ".notificationSettings"
        case let .resetPassword(inviteKey): return ".resetPassword(\(inviteKey.inviteKey))"
        }
    }
}

public enum SheetDestination: Hashable, CustomStringConvertible {
    case groupDescription(group: GroupModel)
    case eventDescription(event: EventModel)

    public var description: String {
        switch self {
        case let .groupDescription(group): return ".groupDescription(\(group))"
        case let .eventDescription(event): return ".eventDescription(\(event))"
        }
    }
}

extension SheetDestination: Identifiable {
    public var id: String {
        switch self {
        case let .groupDescription(group): group.id
        case let .eventDescription(event): event.id
        }
    }
}

public enum FullScreenDestination: Hashable {
    case schedule
}

extension FullScreenDestination: CustomStringConvertible {
    public var description: String {
        switch self {
        case .schedule: return ".schedule"
        }
    }
}

extension FullScreenDestination: Identifiable {
    public var id: String {
        switch self {
        case .schedule: "schedule"
        }
    }
}
