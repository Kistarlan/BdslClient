# Models Rules for BdslClient

Package: `BdslClient/Packages/Common/Models`
Import: `import Models`

---

## 1. Two Model Types

| Type | Location | Conforms to | Purpose |
|---|---|---|---|
| DTO | `Models/DTO/<Domain>/` | `Codable` | Raw API data, used only inside repositories |
| Domain model | `Models/Domain/<Domain>/` | `Equatable, Hashable, Sendable` | Business logic, passed to services and views |

**Rule:** DTOs never leave the repository layer. Services always convert to domain models via `.toDomain()` before returning.

---

## 2. DTO Structure

```swift
public struct UserDTO: Codable {
    public let id: String
    // ...fields

    private enum CodingKeys: String, CodingKey { ... }

    public init(from decoder: Decoder) throws { ... }
    public func encode(to encoder: Encoder) throws { ... }
}

public extension UserDTO {
    func toDomain() -> User {
        User(id: id, ...)
    }
}
```

- `Codable` with explicit `CodingKeys` (never rely on synthesized key mapping for API models).
- `toDomain()` is an extension on the DTO in the **same file**.
- DTOs that can only be decoded (no `encode`) still implement both for symmetry.
- Field names match the Swift convention (camelCase); `CodingKeys` maps to server keys.

---

## 3. Domain Model Structure

```swift
public struct User: Equatable, Hashable, Sendable {
    public let id: String
    // ...fields

    public init(id: String, ...) { ... }
}
```

- Always `struct` (not `class`).
- All properties are `let` (immutable).
- Conform to `Equatable + Hashable + Sendable`.
- Used throughout the app: in services, view models, and views.

---

## 4. Placeholders and Preview Values

All preview/placeholder data lives in `Placeholders.swift`.

| Method | Used for |
|---|---|
| `static func placeholder()` | Skeleton loading (paired with `.redacted` + `.shimmer`) |
| `static func previewValue()` | SwiftUI `#Preview` blocks |

```swift
// Skeleton loading list
(0..<5).map { _ in UserSubscription.placeholder() }

// Preview
UserDTO.previewValue().toDomain()
```

**Rule:** Never hardcode mock data inline in views or previews. Add `placeholder()` / `previewValue()` to `Placeholders.swift`.

DTOs that have only `Decodable` init are built via `JSONSerialization` + `JSONDecoder` in `Placeholders.swift` — this is intentional.

---

## 5. Grouping Utilities

### `GroupedSection<Key, Item>` — generic list grouping

```swift
// Group subscriptions by category key
let sections: [GroupedSection<SubscriptionGroupCategory, UserSubscription>] =
    subscriptions.grouped(by: \.category)

// Or with a closure
subscriptions.grouped { $0.endDate.monthYear }
```

`GroupedSection` is `Identifiable` — its `id` is the `key`. Use it as the data source for `List` + `Section`.

### `ScheduleGroupSection` — schedule-specific grouping by weekday

Used exclusively in the Schedule flow to group events by `Set<DayRecurrenceType>`.

---

## 6. `AppFlowState`

The app auth state enum — accessed via `appState.state`:

```swift
switch appState.state {
case .splash:        // app is bootstrapping
case .unauthenticated:  // no session
case let .authenticated(user):  // user is logged in
}

// Convenience
if appState.state.isAuthenticated { ... }
```

---

## 7. `Endpoint`

Used by repositories to describe an API call:

```swift
Endpoint(
    path: "/events",
    method: .get,
    query: ["filter": filterString]
)

Endpoint(
    path: "/users/\(id)",
    method: .patch,
    body: try JSONEncoder().encode(dto)
)
```

Constructed inline inside repository implementations. Never used outside the repository layer.

---

## 8. Flow Models (`Models/Flows/`)

UI-specific state/grouping models that belong to the `Models` package because they are shared between the app target and services (e.g. filter state passed down to a service call). Keep them in `Models/Flows/<Feature>/`.

---

## 9. Rules Summary

- **Never** use DTOs in views or view models — always domain models.
- **Always** add `toDomain()` as an extension on the DTO, in the same file.
- **Always** make domain models `struct` with `Equatable + Hashable + Sendable`.
- **Always** put preview/placeholder data in `Placeholders.swift`, not inline.
- **Always** use `GroupedSection` + `.grouped(by:)` for sectioned lists.
- **Never** add business logic to domain models — keep them plain data types.
