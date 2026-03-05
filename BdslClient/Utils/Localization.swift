//
//  Localization.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 04.03.2026.
//

import Models
import Foundation

extension DayRecurrenceType {
    var localized : LocalizedStringResource {
        switch self {
        case .monday: return .monday
        case .tueassday: return .tuesday
        case .wednesday: return .wednesday
        case .thursday: return .thursday
        case .friday: return .friday
        case .saturday: return .saturday
        case .sunday: return .sunday
        }
    }
}

extension PaymentMethod {
    var localized: LocalizedStringResource {
        switch self {
        case .cash: return .cash
        case .card: return .card
        case .online: return .online
        case .wayforpay: return .wayForPay
        case .bank: return .bank
        }
    }
}

extension SubscriptionCategory {
    var title: LocalizedStringResource {
        switch self {
        case .active: .activeSubscriptions
        case .expired: .previousSubscriptions
        case .credit: .creditLessons
        case .oneClassTicket: .oneTimeTicket
        case .volonteer: .volonteer
        }
    }
}

extension UserSubscription {
    func localizedPaymentOrNil(locale: Locale) -> String? {
        if let payment = paymentMethod {
            return payment.localized.localized(locale: locale)
        } else {
            return nil
        }
    }
}

extension AppLanguage {
    var displayName: LocalizedStringResource {
        switch self {
        case .system:
            return LocalizedStringResource.system
        case .en:
            return LocalizedStringResource.english
        case .ua:
            return LocalizedStringResource.ukranian
        }
    }
}

extension ThemeMode {
    var displayName: LocalizedStringResource {
        switch self {
        case .system:
            return .system
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}
