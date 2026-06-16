A modern iOS product catalog app built with clean architecture, 
SwiftUI/UIKit, offline-first design, and secure authentication.

---

## Setup Instructions

1. Clone the repo
   ```bash
   git clone git@github.com:Thommzy/product-ios-hub.git
   ```
2. Open `ios-product-hub.xcodeproj` in Xcode 15+
3. Select any iOS 17+ simulator or physical device
4. Hit **⌘ + R** to build and run
5. No third-party dependencies — pure Swift and native frameworks only

---

## Architecture

The app follows **Clean Architecture** with an **MVVM** presentation layer, 
organized into four distinct layers:

```
ios-product-hub/
├── App/            → Entry point, DI container, AppState
├── Core/           → Network, Keychain, SwiftData stack, shared utils
├── Domain/         → Models, repository protocols, use cases (pure Swift)
├── Data/           → Repository implementations, remote and local data sources
└── Presentation/   → ViewModels + SwiftUI views + UIKit login screen
```

### Layer Responsibilities

**Domain** — pure Swift, zero framework imports. Defines models, 
repository protocols, and use cases. Nothing depends on this layer 
except Data and Presentation.

**Data** — implements domain protocols. Handles URLSession networking 
and SwiftData persistence. Never imports SwiftUI or UIKit.

**Presentation** — ViewModels own use cases and expose `@Published` 
state. Views are purely declarative with no business logic.

**Core** — shared infrastructure available to all layers: 
`NetworkService`, `KeychainService`, `SwiftDataStack`, and `AppDIContainer`.

### Key Decisions

| Concern | Choice | Reason |
|---|---|---|
| Architecture | MVVM + Clean Architecture | Clear separation, easy to test |
| Login screen | UIKit | Satisfies UIKit requirement |
| Product screens | SwiftUI | Declarative, pagination-friendly |
| Local storage | SwiftData | Required in spec, simpler than Core Data |
| Secure storage | Keychain | Token persists across app kills |
| Pagination | limit/skip cursor | DummyJSON supports it natively |
| DI | Constructor injection + AppDIContainer | Lightweight, no third-party needed |
| Async | async/await + Task | Modern Swift concurrency throughout |

### SwiftUI + UIKit Interop

The login screen is a `UIViewController` with UIKit layout and 
Combine bindings. A SwiftUI `AnimatedLogoView` is embedded inside 
it via `UIHostingController`, demonstrating both frameworks working 
together on a single screen.

---

## Features

- **Auth** — Username/password login, Face ID/Touch ID, persistent 
  session via Keychain, input validation, loading and error states, 
  spring and shake animations
- **Products** — Paginated list, search, sort and filter by category, 
  product detail with image carousel and reviews, offline cache
- **Favorites** — Add/remove favorites, persisted locally, undo remove 
  with toast animation
- **CRUD** — Add, edit, and delete products locally, reset from API
- **Settings** — Dark/light/system mode, English/Hebrew language 
  switching, logout

---

## AI Usage Report

### Tool Used
Claude (claude.ai)
App icons (appicons.ai)

---

### How I Used It

I used Claude as a sounding board — to validate ideas and speed up 
repetitive work. Everything it suggested was reviewed and adjusted 
before it made it into the codebase.

I used App icons to generate logo and app icons.

---

### What AI Helped With
- Generating the initial `Product` Codable model from the API response
- Hebrew translations for `Localizable.strings`
- Scaffolding unit test structure with mock use cases
- Confirming my offline-first strategy before building it

---

### What I Built Myself
- Full clean architecture and layer boundaries
- `AppDIContainer` dependency wiring
- Offline-first fallback in `ProductRepository`
- Persistent login via Keychain in `AppState.init`
- `UIHostingController` bridge for SwiftUI animation in UIKit
- Combine bindings in `LoginViewController`
- Pagination logic and load-more trigger
- Favorites undo flow
- All `@MainActor` threading fixes for SwiftData

---

### 3 Prompts I Used

**1.** *"Generate a Swift Codable model from this DummyJSON response. 
Needs to be Identifiable, Hashable, with a computed discountedPrice."*

**2.** *"I'm doing offline-first with URLSession + SwiftData — try 
network, cache on success, fall back to cache on failure. Does this 
pattern make sense?"*

**3.** *"Scaffold XCTest unit tests for a ViewModel with protocol-based 
use cases. Cover load success, failure, delete, filter, and favorites."*

---

### How I Verified It
- Read every file line by line before committing
- All unit tests pass
- Manually tested: offline mode, session persistence, dark mode,
  pagination, search, favorites undo, and biometrics on device

---

## Trade-offs, Assumptions & Known Limitations

### Trade-offs

- **SwiftData over Core Data** — SwiftData is simpler and fits the 
  scope of this project. Core Data would be more appropriate for 
  complex relationships or migration-heavy production apps.

- **Simulated auth over real API** — DummyJSON's auth endpoint 
  returns a token but doesn't actually gate the products API. 
  The login validates against known test credentials locally and 
  generates a session token stored in Keychain. In production this 
  would hit a real auth endpoint.

- **UIHostingController for animations** — Rather than rebuilding 
  the login screen in SwiftUI, the animated logo is embedded inside 
  the UIKit screen via `UIHostingController`. This keeps the UIKit 
  demonstration intact while still using SwiftUI animations.

### Assumptions

- The DummyJSON API is treated as the source of truth. Local CRUD 
  operations are device-only and do not sync back to the server 
  since the API does not persist writes.

- Biometric authentication acts as a session unlock rather than 
  a credential replacement. In production it would decrypt a 
  stored credential rather than bypassing the auth check entirely.

- Language switching requires an app restart. This is standard 
  iOS behavior — live language switching without restart requires 
  a full view hierarchy rebuild which is out of scope here.

### Known Limitations

- CRUD changes are lost if the user taps Reset, which re-fetches 
  from the API and overwrites local SwiftData records. This is 
  intentional per the spec but worth noting.

- ProductEntity stores a subset of fields from the full Product 
  model. Nested data like reviews and dimensions are not cached 
  locally — the detail screen will show empty sections in offline 
  mode.

- Hebrew RTL layout is applied at the view level but some UIKit 
  components in the login screen do not fully respect RTL 
  without additional configuration.
