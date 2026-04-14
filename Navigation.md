# Navigation Rules for BdslClient

Package: `BdslClient/Packages/Infrastructure/Navigation`
Import: `import Navigation`

---

## 1. Core Concepts

The navigation system is built around a `Router` observable object that holds all navigation state. It replaces SwiftUI's built-in `NavigationLink` with a programmatic, testable alternative.

### Router hierarchy

```
RootView
└── Router (level 0)          — owned by RootView via @State
    ├── NavigationContainer (subscription tab)  → childRouter(for: .tab(.subscription))
    ├── NavigationContainer (myClasses tab)     → childRouter(for: .tab(.myClasses))
    └── NavigationContainer (schedule tab)      → childRouter(for: .tab(.schedule))
            └── sheet/fullScreen → childRouter(for: .sheet(...) / .fullScreen(...))
```

- The **root router** (`level 0`) is created once in `RootView` and lives for the app's lifetime.
- Each `NavigationContainer` creates (or reuses) a **child router** for its `Destination` via `parentRouter.childRouter(for:)`.
- Sheets and full-screen covers get their own child router automatically inside `NavigationContainer`.

---

## 2. Destination Types

Defined in `Destination.swift` (Navigation package):

| Type | Enum | Used for |
|---|---|---|
| `TabDestination` | `.subscription`, `.myClasses`, `.schedule` | Switching tabs |
| `PushDestination` | `.settings`, `.subsctiptionDetails(userSubscription:)`, etc. | `NavigationStack` push |
| `SheetDestination` | `.groupDescription(group:)`, `.eventDescription(event:)` | Modal sheets |
| `FullScreenDestination` | `.schedule` | Full-screen covers |

All destination types conform to `Hashable`. `SheetDestination` and `FullScreenDestination` also conform to `Identifiable`.

---

## 3. Registering New Destinations

All push, sheet, and full-screen destinations are resolved in **`Destination-ViewMapping.swift`** (app target). This is the only place that maps destinations to views.

### Adding a new PushDestination

1. Add a case to `PushDestination` in `Destination.swift`:
```swift
case myNewScreen(item: MyModel)
```

2. Add a `description` entry in `PushDestination`:
```swift
case let .myNewScreen(item): return ".myNewScreen(\(item.id))"
```

3. Add the view mapping in `Destination-ViewMapping.swift`:
```swift
case let .myNewScreen(item):
    MyNewScreen(viewModel: vmFactory.makeMyNewScreenViewModel(item: item))
```

### Adding a new SheetDestination

1. Add a case to `SheetDestination` and implement `id` (used for `.sheet(item:)`):
```swift
case mySheet(data: MyModel)

public var id: String {
    case let .mySheet(data): data.id
}
```

2. Add the view mapping in `Destination-ViewMapping.swift` inside `view(for destination: SheetDestination)`.

### Adding a new FullScreenDestination

Same pattern as `SheetDestination`, plus implement `id`.

**Rule:** Never hardcode `navigationDestination`, `.sheet(item:)`, or `.fullScreenCover(item:)` in individual views. All routing goes through `NavigationContainer` + `Destination-ViewMapping.swift`.

---

## 4. Accessing the Router

Inject the router from the environment — it is injected by `NavigationContainer`:

```swift
@Environment(Router.self) private var router
```

Use `@Bindable` only when you need to bind directly to router state (e.g. `TabView` selection):

```swift
@Bindable var router: Router
// Usage: TabView(selection: $router.selectedTab)
```

**Rule:** Never create `Router(level:identifierDestination:)` in production views. Only `RootView` creates the root router. For previews use `Router.previewRouter()`.

---

## 5. Navigating

### Push
```swift
router.push(.settings)
router.push(.subsctiptionDetails(userSubscription: subscription))
```

Or use `NavigationButton` for tap-to-navigate:
```swift
NavigationButton(push: .settings) {
    SettingsRowView()
}
```

### Present a sheet
```swift
router.present(sheet: .groupDescription(group: group))
```

Or with `NavigationButton`:
```swift
NavigationButton(sheet: .groupDescription(group: group)) {
    Text("Open")
}
```

### Present full-screen cover
```swift
router.present(fullScreen: .schedule)
```

### Switch tab
```swift
router.select(tab: .schedule)
```

### Navigate to root (pop all)
```swift
router.navigateToRoot()
```

### Pop to a specific screen in the stack (skip intermediate screens)
Use `router.pop(destination:)` to jump back to a particular destination that is already in the stack, bypassing any screens pushed on top of it:
```swift
// e.g. from ResetPasswordScreen jump back to LoginScreen directly
router.pop(destination: .login)
```
This removes the specified destination from `navigationStackPath`. SwiftUI then navigates back to it, skipping any screens between the current screen and the target.

Use this instead of `navigateToRoot()` when you want to land on a specific intermediate screen rather than the root.

---

## 6. NavigationButton

`NavigationButton` is the preferred way to trigger navigation from a tap. It wraps a `Button` internally (which means it is accessible by default) and calls `router.navigate(to:)`.

```swift
// Push
NavigationButton(push: .subsctiptionDetails(userSubscription: subscription)) {
    SubscriptionCard(subscription: subscription)
}

// Sheet
NavigationButton(sheet: .eventDescription(event: event)) {
    EventRow(event: event)
}

// Full screen
NavigationButton(fullScreen: .schedule) {
    Text("Open Schedule")
}

// Generic Destination wrapper
NavigationButton(destination: .push(.settings)) {
    Text("Settings")
}
```

**Rule:** Use `NavigationButton` for tap-to-navigate. Never use `onTapGesture` + `router.push(...)` for primary navigation actions — it breaks VoiceOver.

---

## 7. Dismissing / Popping

### Pop the top screen
```swift
router.pop()
```

### Pop with a return value (result passing)
```swift
// On the child screen — pop and pass a result back
router.pop(result: updatedUser)

// On the parent screen — observe and consume
.onChange(of: router.popResults) { _, _ in
    if let updated: User = router.consumePopResult(for: .changeUserInfo(user: currentUser)) {
        viewModel.updateUser(updated)
    }
}
```

`consumePopResult(for:)` removes the value from the dictionary, so it is safe to call on every change.

### Pop a specific destination
```swift
router.pop(destination: .languageSettings)
```

### Dismiss a sheet
Use SwiftUI's `@Environment(\.dismiss)` inside the sheet, or use the `.addDismissButton(_:)` modifier:
```swift
MySheetView()
    .addDismissButton(.close)
```

---

## 8. NavigationContainer Usage

`NavigationContainer` wraps content in a `NavigationStack` and wires up `navigationDestination`, `.sheet(item:)`, and `.fullScreenCover(item:)` automatically.

### Root-level tab content (in MainTabView)
```swift
NavigationContainer(
    parentRouter: router,
    destination: Destination.tab(.subscription)
) {
    SubscriptionsScreen(...)
}
```

### Preview with router
```swift
#Preview {
    let router = Router.previewRouter()
    NavigationContainer(parentRouter: router) {
        MyScreen(viewModel: ...)
    }
    .setupPreviewEnvironments(.light, router)
}
```

Note: `.setupPreviewEnvironments(_:_:)` accepts an optional `Router` as the second argument to inject it into the environment for previews.

---

## 9. Deep Linking

```swift
router.deepLinkOpen(to: .push(.settings))
```

Only the **active** router handles deep links. `deepLinkOpen` is a no-op on inactive routers, so it is safe to call on any router in the hierarchy.

---

## 10. Rules Summary

- **Never** use `NavigationLink` — use `NavigationButton` or `router.push(...)` instead.
- **Never** create a `Router` in views (except `RootView`). Always use the environment-injected router.
- **Never** add `navigationDestination`, `.sheet(item:)`, or `.fullScreenCover(item:)` directly in views — register them in `Destination-ViewMapping.swift`.
- **Always** use `NavigationButton` for tap-to-navigate (not `onTapGesture`) to preserve accessibility.
- **Always** use `@Environment(Router.self) private var router` to access the router. Use `@Bindable var router` only when binding to router state directly.
- **Always** use `.addDismissButton(_:)` or `@Environment(\.dismiss)` to dismiss sheets — never call `router.pop()` from inside a sheet.
- **Always** use `Router.previewRouter()` in previews. Never instantiate `Router(level:identifierDestination:)` in views.
- **Pop with result:** pass typed values via `router.pop(result:)` and consume with `router.consumePopResult(for:)` in `onChange(of: router.popResults)`.
