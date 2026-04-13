# DesignSystem Rules for BdslClient

Package: `BdslClient/Packages/Common/DesignSystem`
Import: `import DesignSystem`

---

## 1. Accessing the Theme

Every view that needs styling must inject the theme via the environment:

```swift
@Environment(\.theme) private var theme
```

The environment key is defined in `BdslClient/App/Environment/EnvironmentValues.swift`.
The `theme` conforms to the `AppTheme` protocol which exposes three namespaces:
- `theme.colors`   → `DSColors`
- `theme.typography` → `DSTypography`
- `theme.layout`   → `DSLayout` (contains `.spacing` and `.cornerRadius`)
- `theme.scheme`   → `ThemeScheme` (`.light` / `.dark`) — use only when a value truly differs between schemes (e.g. location hex colors).

**Rule:** Never instantiate `LightTheme()` or `DarkTheme()` directly in production views. Only use the injected `theme`.

---

## 2. Colors (`theme.colors`)

Always use semantic color tokens. Never use hardcoded SwiftUI colors (`.gray`, `.blue`, `.red`, etc.) or literal hex values.

### Text
| Token | Use when |
|---|---|
| `theme.colors.textPrimary` | Main content text, headings, labels |
| `theme.colors.textSecondary` | Supporting info, captions, placeholders |
| `theme.colors.textDisabled` | Disabled state text |
| `theme.colors.textError` | Inline validation / error messages |

### Backgrounds
| Token | Use when |
|---|---|
| `theme.colors.appBackground` | Full-screen background, `ScrollView` background |
| `theme.colors.cardBackground` | Cards, rows, grouped containers |
| `theme.colors.surfaceSecondary` | Nested surfaces inside cards |
| `theme.colors.loginBackground` | Login/splash screen only |

### Controls & Icons
| Token | Use when |
|---|---|
| `theme.colors.iconSecondary` | Secondary icon tint (person, gear, etc.) |
| `theme.colors.accent` | Primary interactive color, links, active indicators |
| `theme.colors.divider` | `Divider()` views, separator lines |
| `theme.colors.materialBorder` | Subtle card/overlay borders |

### Buttons
| Token | Use when |
|---|---|
| `theme.colors.buttonPrimaryBackground` | Enabled primary button background |
| `theme.colors.buttonPrimaryForeground` | Enabled primary button label |
| `theme.colors.buttonPrimaryDisabledBackground` | Disabled primary button background |
| `theme.colors.buttonPrimaryDisabledForeground` | Disabled primary button label |
| `theme.colors.buttonDisabled` | Login screen disabled button only |
| `theme.colors.backgroundSecondary` | Login screen secondary button only |

### TextFields
| Token | Use when |
|---|---|
| `theme.colors.textFieldBorder` | Default border |
| `theme.colors.textFieldBorderFocused` | Focused border |
| `theme.colors.textFieldBorderError` | Error state border |
| `theme.colors.textFieldBackground` | Field background |
| `theme.colors.textFieldBackgroundDisabled` | Disabled field background |

### Badges
| Token | Use when |
|---|---|
| `theme.colors.badgeActive` | Active subscription status |
| `theme.colors.badgeCredit` | Credit subscription status |
| `theme.colors.badgeInactive` | Expired / inactive status |
| `theme.colors.badgeWarning` | Expiring-soon warning |
| `theme.colors.badgeTextOnColor` | Text on any badge background (always white) |

### Chips / Filter Tags
| Token | Use when |
|---|---|
| `theme.colors.chipBackground` | Unselected chip background |
| `theme.colors.chipBorder` | Unselected chip border |
| `theme.colors.chipText` | Unselected chip text |
| `theme.colors.chipSelectedBackground` | Selected chip background |
| `theme.colors.chipSelectedBorder` | Selected chip border |
| `theme.colors.chipSelectedText` | Selected chip text |
| `theme.colors.secondaryChipText` | Text inside activity-colored chips |

### Color utility
`Color(hex: String)` is available from `ColorExtension.swift` (DesignSystem package).
Use it **only** for data-driven colors coming from the API (e.g. `location.colorHex`, `activity.colorHex`).
For theme-scheme–sensitive data colors, use `theme.scheme`:
```swift
let hex = theme.scheme == .dark ? location.color2Hex : location.colorHex
```

---

## 3. Typography (`theme.typography`)

Always use typography tokens. Never use `.font(.system(size:))` or raw Dynamic Type values like `.font(.body)` directly — use the token so all screens stay consistent.

| Token | Semantic meaning |
|---|---|
| `theme.typography.largeTitle` | Hero / splash large display text |
| `theme.typography.screenTitle` | Navigation title or page header |
| `theme.typography.sectionTitle` | Section heading within a screen |
| `theme.typography.cardTitle` | Primary label inside a card |
| `theme.typography.body` | Standard paragraph / form text |
| `theme.typography.secondary` | Supporting text, subtitles |
| `theme.typography.caption` | Small annotations, dates, metadata |
| `theme.typography.button` | Button labels |
| `theme.typography.label` | Badge text, small tag labels |
| `theme.typography.input` | TextField input text |
| `theme.typography.error` | Inline error messages |

You may call `.weight()` on a token when a specific weight is required (e.g. `theme.typography.secondary.weight(.semibold)`), but keep this to a minimum.

---

## 4. Spacing (`theme.layout.spacing`)

All padding, stack spacing, and frame sizes must use spacing tokens. Never use magic numbers.

| Token | Value | Use for |
|---|---|---|
| `theme.layout.spacing.xxs` | 2 | Micro gaps (e.g. between icon and hairline) |
| `theme.layout.spacing.xs` | 4 | Tight inner padding, badge padding |
| `theme.layout.spacing.s` | 8 | Compact gaps, sub-item spacing |
| `theme.layout.spacing.sm` | 12 | Medium-small gaps (chips, filter rows) |
| `theme.layout.spacing.m` | 16 | Standard padding (card inner, row padding) |
| `theme.layout.spacing.ml` | 24 | Section gaps, between groups |
| `theme.layout.spacing.l` | 32 | Large padding, section separators |
| `theme.layout.spacing.xl` | 48 | Page-level breathing room |
| `theme.layout.spacing.xxl` | 64 | Splash/hero extra space |

**Legacy constants** in `CGFloat+.swift` (`CGFloat.spacingM`, etc.) exist but **prefer `theme.layout.spacing.*`** in all new views since they are theme-aware.

---

## 5. Corner Radius (`theme.layout.cornerRadius`)

| Token | Value | Use for |
|---|---|---|
| `theme.layout.cornerRadius.xs` | 4 | Minimal rounding (chips when very tight) |
| `theme.layout.cornerRadius.s` | 8 | Inner elements, tags |
| `theme.layout.cornerRadius.m` | 14 | Cards, primary interactive elements |
| `theme.layout.cornerRadius.l` | 16 | Large containers, grouped settings sections |

Always use `.clipShape(.rect(cornerRadius: theme.layout.cornerRadius.m))` not the deprecated `.cornerRadius()`.

---

## 6. Helper Modifiers & Components

### `applyGroupContainerStyle(_:)`
Applies `cardBackground` fill and `.l` corner radius. Use for grouped settings containers.
```swift
// Defined on VStack extension
VStack { ... }
    .applyGroupContainerStyle(theme)
```

### `bottomDivider(_:_:)`
Adds a theme-colored `Divider` below the view. Used between rows in grouped lists.
```swift
RowView()
    .bottomDivider()                          // full width
    .bottomDivider(.horizontal, theme.layout.spacing.m) // with horizontal inset
```

### `roundedBorder(radius:borderColor:lineWidth:)`
Clips to a rounded rect and strokes a border. Used on cards.
```swift
.roundedBorder(
    radius: theme.layout.cornerRadius.m,
    borderColor: theme.colors.materialBorder
)
```

### `shimmer(active:)`
Animated loading shimmer overlay. Pair with `.redacted(reason: .placeholder)`.
```swift
CardView()
    .redacted(reason: isLoading ? .placeholder : [])
    .shimmer(active: isLoading)
    .disabled(isLoading)
```

### `BackgroundView`
Full-screen gradient background that respects the current theme. Use in screen roots.
```swift
ZStack {
    BackgroundView().ignoresSafeArea()
    // content
}
```

### `LoginBackgroundView`
Branded login/splash background. Use only on the auth flow screens.

---

## 7. Previews

Always use `.setupPreviewEnvironments(_:_:)` in `#Preview` blocks:
```swift
#Preview {
    MyView()
        .setupPreviewEnvironments(.light)   // or .dark
}
```
This injects `theme`, `locale`, `AppState`, and a preview `Router` in one call.

---

## 8. Rules Summary

- **Never** use `.foregroundColor()` — always `.foregroundStyle()`
- **Never** use `.tint()` on `Text` — use `.foregroundStyle()`
- **Never** hardcode colors: no `.gray`, `.blue`, `.red`, `.white`, `.black` in views (exception: data-driven hex from API)
- **Never** hardcode spacing: no magic numbers like `padding(12)` or `spacing: 4`
- **Never** instantiate `LightTheme()` / `DarkTheme()` in views (previews excepted)
- **Never** use `CGFloat.spacingM` etc. in new views — use `theme.layout.spacing.*`
- **Always** add `import DesignSystem` when using `AppTheme`, `DSColors`, `DSTypography`, etc.
- **Always** add `@Environment(\.theme) private var theme` as the first property in views that need styling
