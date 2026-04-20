//
//  SubscriptionSettings.swift
//  Models
//
//  Created by Oleh Rozkvas on 20.04.2026.
//

public struct SubscriptionSettings: Sendable {
    public let teachersRatesForVolunteer: Int
    public let teachersRatesForRegular: Int
    public let teachersRatesForBase: Int
    public let teachersRatesForTicket: Int
    public let teachersRatesForCredit: Int
    public let ticketPrice: Int
    public let subscriptionPricesBase: Int
    public let subscriptionPricesSteps: Int
    public let subscriptionPricesUnlimStartsFrom: Int
    public let subscriptionPricesHoursPerStep: Int
    public let subscriptionPricesHoursPerActivity: Int

    public init(
        teachersRatesForVolunteer: Int,
        teachersRatesForRegular: Int,
        teachersRatesForBase: Int,
        teachersRatesForTicket: Int,
        teachersRatesForCredit: Int,
        ticketPrice: Int,
        subscriptionPricesBase: Int,
        subscriptionPricesSteps: Int,
        subscriptionPricesUnlimStartsFrom: Int,
        subscriptionPricesHoursPerStep: Int,
        subscriptionPricesHoursPerActivity: Int
    ) {
        self.teachersRatesForVolunteer = teachersRatesForVolunteer
        self.teachersRatesForRegular = teachersRatesForRegular
        self.teachersRatesForBase = teachersRatesForBase
        self.teachersRatesForTicket = teachersRatesForTicket
        self.teachersRatesForCredit = teachersRatesForCredit
        self.ticketPrice = ticketPrice
        self.subscriptionPricesBase = subscriptionPricesBase
        self.subscriptionPricesSteps = subscriptionPricesSteps
        self.subscriptionPricesUnlimStartsFrom = subscriptionPricesUnlimStartsFrom
        self.subscriptionPricesHoursPerStep = subscriptionPricesHoursPerStep
        self.subscriptionPricesHoursPerActivity = subscriptionPricesHoursPerActivity
    }
}
