//
//  MockUserSubscriptionsService.swift
//  BdslClientTests
//

import Models
import Services

final class MockUserSubscriptionsService: UserSubscriptionsService, @unchecked Sendable {
    var fetchSubscriptionsResult: Result<[UserSubscription], Error> = .success([])
    var fetchAttendeesResult: Result<[AttendeeModel], Error> = .success([])
    var loadUpcomingClassesResult: Result<[UpcomingClassModel], Error> = .success([])

    func fetchUserSubscriptions(for userId: String, forceReload: Bool) async throws -> [UserSubscription] {
        try fetchSubscriptionsResult.get()
    }

    func fetchSubscriptionAttendees(userSubscription: UserSubscription, forceReload: Bool) async throws -> [AttendeeModel] {
        try fetchAttendeesResult.get()
    }

    func loadUpcomingClasses(for userId: String, range: ClassGeneratingRange, forceReload: Bool) async throws -> [UpcomingClassModel] {
        try loadUpcomingClassesResult.get()
    }

    func clearCache() async {}
    func clearUserCache() async {}
}
