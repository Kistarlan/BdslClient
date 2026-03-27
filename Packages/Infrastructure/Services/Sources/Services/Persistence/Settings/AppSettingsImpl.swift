//
//  AppSettingsImpl.swift
//  Services
//
//  Created by Oleh Rozkvas on 25.03.2026.
//

import Foundation
import Models

final class AppSettingsImpl: @unchecked Sendable, AppSettings {
    private let userDefaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private enum Keys {
        static let theme = "themeMode"
        static let language = "language"
        static let notification = "notificationLeadTime"
    }

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    var themeMode: ThemeMode {
        get {
            ThemeMode(rawValue: userDefaults.string(forKey: Keys.theme) ?? "") ?? .system
        }
        set {
            userDefaults.set(newValue.rawValue, forKey: Keys.theme)
        }
    }

    var appLanguage: AppLanguage {
        get {
            AppLanguage(rawValue: userDefaults.string(forKey: Keys.language) ?? "") ?? .system
        }
        set {
            userDefaults.set(newValue.rawValue, forKey: Keys.language)
        }
    }

    var notificationLeadTime: NotificationLeadTime {
        get {
            guard let data = userDefaults.data(forKey: Keys.notification),
                  let value = try? decoder.decode(NotificationLeadTime.self, from: data)
            else {
                return .disabled
            }

            return value
        }
        set {
            let data = try? encoder.encode(newValue)
            userDefaults.set(data, forKey: Keys.notification)
        }
    }
}
