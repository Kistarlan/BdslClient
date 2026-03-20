//
//  AppServices.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 06.02.2026.
//

import Models
import Configs

public struct AppServices {

    // MARK: - Core
    public let tokenStore: TokenStore

    // MARK: - Repositories (only those exposed outside)

    public let authRepository: AuthRepository

    // MARK: - Services

    public let usersService: UsersService
    public let imageService: ImageService
    public let userSubscriptionsService: UserSubscriptionsService
    public let eventsService: EventsService
    public let groupsService: GroupsService
    public let cachingManager: CachingManager

    // MARK: - Designated initializer (builds service graph)
    public init(
        tokenStore: TokenStore,
        authRepository: AuthRepository,
        usersRepository: UsersRepository,
        imageRepository: ImageRepository,
        userSubscriptionsRepository: UserSubscriptionsRepository,
        activitiesRepository: ActivityRepository,
        eventsRepository: EventsRepository,
        levelsRepository: LevelsRepository,
        locationsRepository: LocationsRepository,
        teachersRepository: TeachersRepository,
        groupsRepository: GroupsRepository
    ) {
        self.tokenStore = tokenStore
        self.authRepository = authRepository

        usersService = UsersServiceImpl(
            usersRepository: usersRepository
        )

        imageService = ImageServiceImpl(
            imageRepository: imageRepository
        )

        let teachersService = TeachersServiceImpl(
            teacherRepository: teachersRepository,
            usersService: usersService
        )

        let activityService = ActivityServiceImpl(
            activityRepository: activitiesRepository
        )

        let locationsService = LocationServiceImpl(
            locationsRepository: locationsRepository
        )

        let levelsService = LevelsServiceImpl(
            levelsRepository: levelsRepository
        )

        eventsService = EventsServiceImpl(
            eventsRepository: eventsRepository,
            teacherService: teachersService,
            activityService: activityService,
            locationsService: locationsService,
            levelsService: levelsService
        )

        userSubscriptionsService = UserSubscriptionsServiceImpl(
            userSubscriptionsRepository: userSubscriptionsRepository,
            eventsService: eventsService
        )

        cachingManager = CachingManagerImpl(services: [any CacheableService](
            [
                imageService as any CacheableService,
                teachersService as any CacheableService,
                activityService as any CacheableService,
                locationsService as any CacheableService,
                levelsService as any CacheableService,
                eventsService as any CacheableService,
                userSubscriptionsService as any CacheableService,
            ]
        ))

        groupsService = GroupsServiceImpl(groupsRepository: groupsRepository)
    }
}

public extension AppServices {
    static var shared: AppServices {
        let tokenStore = KeychainTokenStore(service: Config.tokenStoreService)
        let jwtDecoder = JwtDecoderImpl()
        let apiClient = APIClientImpl(tokenStore: tokenStore, jwtDecoder: jwtDecoder)
        let sseClient = SSEClient()

        let authRepository = AuthRepositoryImpl(
            apiClient: apiClient,
            tokenStore: tokenStore,
            jwtDecoder: jwtDecoder,
            sseClient: sseClient
        )

        let usersRepository = UsersRepositoryImpl(
            apiClient: apiClient,
            tokenStore: tokenStore
        )

        let imageRepository = ImageRepositoryImpl(
            apiClient: apiClient
        )

        let userSubscriptionsRepository = UserSubscriptionRepositoryImpl(
            apiClient: apiClient
        )

        let activitiesRepository = ActivityRepositoryImpl(
            apiClient: apiClient
        )

        let eventsRepository = EventsRepositoryImpl(
            apiClient: apiClient
        )

        let levelsRepository = LevelsRepositoryImpl(
            apiClient: apiClient
        )

        let locationsRepository = LocationsRepositoryImpl(
            apiClient: apiClient
        )

        let teachersRepository = TeachersRepositoryImpl(
            apiClient: apiClient
        )

        let groupsRepository = GroupsRepositoryImpl(
            apiClient: apiClient
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
            groupsRepository: groupsRepository
        )
    }
}
