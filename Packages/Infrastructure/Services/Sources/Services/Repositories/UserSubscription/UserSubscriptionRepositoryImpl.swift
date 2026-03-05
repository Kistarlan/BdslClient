//
//  UserSubscriptionRepositoryImpl.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 21.02.2026.
//

import Models
import OSLog
import MongoFilters

final class UserSubscriptionRepositoryImpl: UserSubscriptionsRepository {
    private let logger = Logger.forCategory(String(describing: UserSubscriptionsRepository.self))
    let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func fetchUserSubscriptions(for userId: String) async throws -> [UserSubscriptionDTO] {
        do {
            let endpoint = try getEndpointWithUserFilters(path: "/usersubscriptions", userId: userId)

            let dtos: [UserSubscriptionDTO] = try await apiClient.request(endpoint)

            let models = dtos.filter { $0.userId == userId }

            return models
        } catch {
            logger.warning("Failed to fetch user subscriptions: \(error)")
            throw error
        }
    }

    func fetchSubscriptionAttendees(for userId: String) async throws -> [AttendeeDTO]{
        let endpoint = try getEndpointWithUserFilters(path: "/attendees", userId: userId)

        return try await apiClient.request(endpoint)
    }

    func getEndpointWithUserFilters(path: String, userId: String) throws -> Endpoint {
        let filter = Filter.In("user", [userId])
        let filterString = try filter.makeFilterQuery()

        return Endpoint(
            path: path,
            method: .get,
            query: [
                "filter": filterString
            ]
        )
    }
}

