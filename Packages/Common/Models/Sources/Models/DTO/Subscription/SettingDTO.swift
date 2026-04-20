//
//  SettingDTO.swift
//  Models
//
//  Created by Oleh Rozkvas on 20.04.2026.
//

public struct SettingDTO: Codable, Sendable {
    public let id: String
    public let name: String
    public let value: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case value
    }
}

public extension Array where Element == SettingDTO {
    func toDomain() -> SubscriptionSettings {
        let dict = Dictionary(uniqueKeysWithValues: map { ($0.name, $0.value) })
        func int(_ key: String) -> Int { Int(dict[key] ?? "0") ?? 0 }

        return SubscriptionSettings(
            teachersRatesForVolunteer: int("teachers_rates_for_volunteer"),
            teachersRatesForRegular: int("teachers_rates_for_regular"),
            teachersRatesForBase: int("teachers_rates_for_base"),
            teachersRatesForTicket: int("teachers_rates_for_ticket"),
            teachersRatesForCredit: int("teachers_rates_for_credit"),
            ticketPrice: int("ticket_price"),
            subscriptionPricesBase: int("subscription_prices.base"),
            subscriptionPricesSteps: int("subscription_prices.steps"),
            subscriptionPricesUnlimStartsFrom: int("subscription_prices.unlim_starts_from"),
            subscriptionPricesHoursPerStep: int("subscription_prices.hours_per_step"),
            subscriptionPricesHoursPerActivity: int("subscription_prices.hours_per_activity")
        )
    }
}
