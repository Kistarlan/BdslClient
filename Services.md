# Services Rules for BdslClient

Package: `BdslClient/Packages/Infrastructure/Services`
Import: `import Services`

---

## 1. Architecture Overview

The service layer is split into three layers, from bottom to top:

```
APIClient (Networking)
    ↓  raw HTTP + Decodable
Repository (Protocol + Impl)
    ↓  DTOs only
Service (Protocol + Impl)
    ↓  domain models, business logic, caching
ViewModel
    ↓  state for the View
View
```

- **Repositories** talk to the network (via `APIClient`) and return `DTO` types from the `Models` package.
- **Services** depend on repositories (and optionally other services), map DTOs to domain models via `.toDomain()`, and apply business logic and caching.
- **ViewModels** depend only on service protocols — never on repositories or `APIClient` directly.

---

## 2. Repository Pattern

### Protocol

```swift
// Location: Services/Repositories/<Domain>/<Name>Repository.swift
public protocol EventsRepository: Sendable {
    func fetchEvents() async throws -> [EventDTO]
    func fetchEventsFor(_ ids: [String]) async throws -> [EventDTO]
    func fetchActualEvents(minEndDate: Date, _ exceptIds: [String]) async throws -> [EventDTO]
}
```

- Must conform to `Sendable`.
- All methods are `async throws`.
- Return types are **always DTOs** (`XxxDTO`) from the `Models` package — never domain models.
- Marked `public` so they are accessible from `AppServices`.

### Implementation

```swift
// Location: Services/Repositories/<Domain>/<Name>RepositoryImpl.swift
final class EventsRepositoryImpl: EventsRepository {
    let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func fetchEvents() async throws -> [EventDTO] {
        let endpoint = Endpoint(path: "/events", method: .get)
        return try await apiClient.request(endpoint)
    }
}
```

- `final class`, **package-private** (no `public`) — implementation details are hidden.
- Injects `APIClient` via init.
- Constructs `Endpoint` inline and delegates to `apiClient.request(_:)`.
- No business logic, no caching, no domain model mapping.

---

## 3. Service Pattern

### Protocol

```swift
// Location: Services/Domain/<Domain>/<Name>Service.swift
public protocol EventsService: CacheableService {
    func fetchEvent(for id: String, forceReload: Bool) async throws -> EventModel
    func fetchEvents(for ids: [String], forceReload: Bool) async throws -> [EventModel]
    func fetchActualEvents(forceReload: Bool) async throws -> [EventModel]
}
```

- Must conform to `Sendable` (directly or via `CacheableService`).
- All methods are `async throws`.
- Return types are **domain models** from the `Models` package.
- Conform to `CacheableService` if the service holds in-memory cached data.
- Marked `public` so `AppServices` can expose the protocol type.

### Implementation

```swift
// Location: Services/Domain/<Domain>/<Name>ServiceImpl.swift
final class EventsServiceImpl: EventsService {
    private let logger = Logger.forCategory(String(describing: EventsServiceImpl.self))
    private let cache = Cache<String, EventModel>()
    private let eventsRepository: EventsRepository
    // ...other service dependencies

    init(eventsRepository: EventsRepository, ...) { ... }

    func fetchEvent(for id: String, forceReload: Bool) async throws -> EventModel { ... }

    func clearCache() async {
        await cache.clear()
    }
}
```

- `final class`, **package-private** — never expose `Impl` types to the app target.
- Injects repositories and other services via init.
- Converts DTOs to domain models: `dto.toDomain()`.
- Uses `Cache<Key, Value>` actor for thread-safe in-memory caching.
- Implements `clearCache()` from `CacheableService` when caching is used.
- Uses `Logger.forCategory(String(describing: Self.self))` for structured logging.

---

## 4. Caching

### `Cache<Key, Value>` actor

A generic, thread-safe cache backed by a dictionary:

```swift
private let cache = Cache<String, EventModel>()

// Read
if let event = await cache[id] { return event }

// Write
await cache.add(key: model.id, value: model)

// Delete
await cache.remove(forKey: id)

// Clear all
await cache.clear()
```

All operations are `async` because `Cache` is an `actor`.

### `forceReload: Bool` parameter

Services that cache data expose a `forceReload` parameter:

```swift
func fetchEvents(for ids: [String], forceReload: Bool) async throws -> [EventModel]
```

- `forceReload: false` — serve from cache if available; fetch from network only for misses.
- `forceReload: true` — evict affected cache entries before fetching.

**Rule:** Always add `forceReload: Bool` to service methods that can benefit from caching. Pass `forceReload` down to sub-services when clearing is appropriate.

### `CacheableService` protocol

Services with caches must conform to `CacheableService`:

```swift
public protocol CacheableService: Sendable {
    func clearCache() async
}
```

Conforming services are registered in `CachingManagerImpl` during `AppServices` construction and their caches are cleared on:
- Full logout (`cachingManager.clearFullCache()`)
- User change (`cachingManager.clearUserCache()` — for `UserCacheableService` conformers)

---

## 5. `AppServices` — Composition Root

`AppServices` is the single place that builds and owns all services. It lives in the Services package.

### Exposed properties (what consumers can use)

```swift
public struct AppServices {
    public let tokenStore: TokenStore
    public let authRepository: AuthRepository   // exposed because AppState needs it directly
    public let usersService: UsersService
    public let imageService: ImageService
    public let userSubscriptionsService: UserSubscriptionsService
    public let eventsService: EventsService
    public let groupsService: GroupsService
    public let cachingManager: CachingManager
    public let notificationManager: NotificationManager
    public let permissionService: PermissionService
    public let appSettings: AppSettings
}
```

- Only **protocol types** are exposed — never `Impl` classes.
- Repositories that are internal to the service graph are **not** exposed; they are created locally in `AppServices.buildServices(_:)` and passed to the service initializers.

### Building the graph

`AppServices.buildServices(_:)` is the static factory that creates all repositories and wires the full dependency graph. It is the only place where `Impl` types are instantiated:

```swift
let apiClient = APIClientImpl(tokenStore: tokenStore, jwtDecoder: jwtDecoder)
let eventsRepository = EventsRepositoryImpl(apiClient: apiClient)
let eventsService = EventsServiceImpl(eventsRepository: eventsRepository, ...)
```

**Rule:** Never create `RepositoryImpl` or `ServiceImpl` instances outside of `AppServices`. All wiring happens in `buildServices(_:)` or the `AppServices` init.

---

## 6. `AppContainer` — App-Level Composition

`AppContainer` is a singleton that lives in the app target. It owns `AppServices`, `AppState`, and `ViewModelsFactory`.

```swift
final class AppContainer {
    static let shared: AppContainer = { ... }()

    let services: AppServices
    let appState: AppState
    let viewModelsFactory: ViewModelsFactory
}
```

**Rule:** Access `AppContainer.shared` **only** from `ViewModelsFactory` and `AppState` construction. Never inject `AppContainer.shared` directly into views or view models.

Exception: `ToolbarItems` components that are inserted globally and cannot easily receive DI (e.g. `SettingsButton`) may access `AppContainer.shared.services.*` directly, but this should be kept to a minimum.

---

## 7. `ViewModelsFactory` — ViewModel Construction

`ViewModelsFactory` is the only place that creates ViewModels. It receives `AppServices` and `AppState` at init time.

```swift
struct ViewModelsFactory {
    private let appServices: AppServices
    private let appState: AppState

    func makeScheduleViewModel() -> ScheduleViewModel {
        ScheduleViewModel(
            appState: appState,
            groupsService: appServices.groupsService
        )
    }
}
```

**Rules:**
- Every `make*` function creates a **new** ViewModel instance (ViewModels are owned by views via `@State`).
- ViewModels receive only the specific service protocols they need — not the entire `AppServices` struct.
- `AppState` is passed alongside services when the ViewModel needs to observe or modify app-wide state.
- Preview variants (`makePreview*`) live in a separate `extension ViewModelsFactory` block.

---

## 8. ViewModel Pattern

ViewModels in this project use `@Observable` + `@MainActor`:

```swift
@Observable
@MainActor
final class ScheduleViewModel {
    private let groupsService: GroupsService
    private let appState: AppState

    init(appState: AppState, groupsService: GroupsService) {
        self.appState = appState
        self.groupsService = groupsService
    }

    func fetchData(forceReload: Bool) async {
        do {
            // ...
        } catch {
            // handle error
        }
    }
}
```

- Services are **injected via init** as protocol types — never fetched from `AppContainer.shared` inside the VM.
- Service calls are `await`ed directly in `async` methods. Do not use `Task { }` inside ViewModels unless explicitly detaching work.
- ViewModels are created via `ViewModelsFactory`, owned by views with `@State`, and passed as `@Bindable` when needed.

---

## 9. How to Add a New Service

### Step-by-step

1. **Create the repository protocol** in `Services/Repositories/<Domain>/<Name>Repository.swift`:
   - `public protocol <Name>Repository: Sendable`
   - Methods return DTOs only

2. **Create the repository implementation** in `Services/Repositories/<Domain>/<Name>RepositoryImpl.swift`:
   - `final class <Name>RepositoryImpl: <Name>Repository`
   - Injects `APIClient`, constructs `Endpoint`, calls `apiClient.request(_:)`

3. **Create the service protocol** in `Services/Domain/<Domain>/<Name>Service.swift`:
   - `public protocol <Name>Service: CacheableService` (or just `: Sendable` if no cache)
   - Methods return domain models

4. **Create the service implementation** in `Services/Domain/<Domain>/<Name>ServiceImpl.swift`:
   - `final class <Name>ServiceImpl: <Name>Service`
   - Injects repository and any dependent services
   - Adds `Cache<String, DomainModel>()` if caching is needed
   - Implements `clearCache()` if conforming to `CacheableService`
   - Maps DTOs to domain via `.toDomain()`

5. **Register in `AppServices`**:
   - Add `public let <name>Service: <Name>Service` to `AppServices`
   - Instantiate `<Name>RepositoryImpl` and `<Name>ServiceImpl` in `buildServices(_:)`
   - Pass to the `AppServices` init
   - Add to `CachingManagerImpl` array if `CacheableService`

6. **Expose in `ViewModelsFactory`** if ViewModels need it:
   - Add to the relevant `make*ViewModel()` function

---

## 10. Rules Summary

- **Never** expose `Impl` types — only protocol types in `AppServices` properties.
- **Never** create `RepositoryImpl` / `ServiceImpl` outside of `AppServices`.
- **Never** let a ViewModel access `AppContainer.shared` — inject services via `ViewModelsFactory`.
- **Never** let a Repository return domain models — always return DTOs.
- **Never** let a Service return DTOs — always return domain models.
- **Always** conform service protocols to `Sendable`.
- **Always** conform services with in-memory caches to `CacheableService` and register them in `CachingManagerImpl`.
- **Always** add a `forceReload: Bool` parameter to service methods that cache data.
- **Always** use `Cache<Key, Value>` actor for in-memory caching (not `Dictionary` or `NSCache`).
- **Always** use `Logger.forCategory(String(describing: Self.self))` for logging in service implementations.
- **Always** add new ViewModels via a `make*` function in `ViewModelsFactory`, not inline in views.
