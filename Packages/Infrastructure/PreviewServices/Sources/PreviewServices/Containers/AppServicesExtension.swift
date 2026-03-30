//
//  AppServicesExtension.swift
//  PreviewServices
//
//  Created by Oleh Rozkvas on 04.03.2026.
//

import Configs
import Models
import Services

public extension AppServices {
    static func buildPreviewServices(notificationBuilder: NotificationBuilder) -> AppServices {
        let tokenStore = KeychainTokenStore(service: Config.tokenStoreService)

        let previewDataProvider = PreviewDataService()

        let authRepository = PreviewAuthRepository(
            tokenStore: tokenStore,
            jwtDecoder: JwtDecoderImpl(),
            previewJwtPayloadDTO: JwtPayloadDTO.previewValue()
        )

        let usersRepository = PreviewUsersRepository(
            previewDataProvider: previewDataProvider
        )

        let imageRepository = PreviewImageRepository()

        let userSubscriptionsRepository = PreviewUserSubscriptionRepository(
            previewDataProvider: previewDataProvider
        )

        let activitiesRepository = PreviewActivityRepository(
            previewDataProvider: previewDataProvider
        )

        let eventsRepository = PreviewEventsRepository(
            previewDataProvider: previewDataProvider
        )

        let levelsRepository = PreviewLevelsRepository(
            previewDataProvider: previewDataProvider
        )

        let locationsRepository = PreviewLocationsRepository(
            previewDataProvider: previewDataProvider
        )

        let teachersRepository = PreviewTeachersRepository(
            previewDataProvider: previewDataProvider
        )

        let groupsRepository = PreviewGroupsRepository(
            previewDataProvider: previewDataProvider
        )

        return AppServices(
            tokenStore: tokenStore,
            authRepository: authRepository,
            usersRepository: usersRepository,
            imageRepository: imageRepository,
            userSubscriptionsRepository: userSubscriptionsRepository,
            activitiesRepository: activitiesRepository,
            eventsRepository: eventsRepository,
            levelsRepository: levelsRepository,
            locationsRepository: locationsRepository,
            teachersRepository: teachersRepository,
            groupsRepository: groupsRepository,
            notificationBuilder: notificationBuilder
        )
    }
}
