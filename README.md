# The Legion

A production-oriented Flutter foundation built with **feature-based Clean Architecture**.

Targets **Android, iOS and Web** from a single codebase.

| Concern | Choice |
| --- | --- |
| State management | `flutter_bloc` (Cubit) |
| Networking | `dio` |
| Dependency injection | `get_it` |
| Local cache | `hive_ce` (Hive Community Edition) |
| Secure storage | `flutter_secure_storage` |
| Navigation | `go_router` |
| Value equality | `equatable` |
| Logging | `logger` |
| Localization | `flutter_localizations` + `intl` (gen-l10n) |
| Testing | `flutter_test`, `bloc_test`, `mocktail` |

---

## Requirements

| Tool | Version used to verify this project |
| --- | --- |
| Flutter | 3.47.6 (stable) |
| Dart | 3.13.5 |
| Android SDK | 37 (compile/target from `flutter.compileSdkVersion`) |
| Xcode | 26.x (CocoaPods required for `pod install`) |

Dart package name: `the_legion_mobile` (Dart identifiers cannot contain
hyphens; the repository/folder may be `the-legion-mobile`).

Check your toolchain with `flutter doctor`.

---

## Design system

The theme implements the **Institutional Sovereign** specification
(`ui-designs/institutional_sovereign/DESIGN.md`, cross-checked against the
Tailwind tokens in the exported `code.html` designs):

* **Brand** — brand navy `#0F3F6B` for primary actions, honey gold `#E6B841`
  as the premium attention anchor.
* **Surfaces** — a canvas → card → subtle ramp separated by 1px hairline
  strokes instead of shadows; dark mode inverts the primary action to gold.
* **Type** — Inter (prose) and JetBrains Mono (identifiers, dates, currency),
  bundled in `assets/fonts` at 400/500/600/700.
* **Geometry** — 44px controls, 20px cards and dialogs, 10px inputs and
  buttons, fully-rounded status pills, strict 4px/8px spacing scale.

Tokens live in `lib/core/theme/` (`app_colors`, `app_text_styles`,
`app_spacing`, `app_radii`, `app_theme`) plus `AppDimensions` in
`core/utils/responsive.dart`. Never hardcode a colour, font size, spacing or
radius in a widget — see [ARCHITECTURE.md](ARCHITECTURE.md#8-design-system--institutional-sovereign).

## Setup

```bash
flutter pub get
flutter gen-l10n        # regenerate lib/core/l10n/gen after editing the .arb files
```

`flutter gen-l10n` also runs automatically during `flutter pub get` because
`generate: true` is set in `pubspec.yaml`.

---

## Running

```bash
# Android (device or emulator)
flutter run

# iOS (simulator)
open -a Simulator
flutter run -d <ios-simulator-id>

# Web
flutter run -d chrome
```

Builds:

```bash
flutter build apk --release
flutter build appbundle --release
flutter build ios --release
flutter build web --release
```

---

## Environment configuration

Configuration is compile-time only (`--dart-define`), so no base URL is ever
hardcoded in a feature and no secret lives in the repository.

| Dart-define | Default | Purpose |
| --- | --- | --- |
| `ENVIRONMENT` | `development` | `development` / `staging` / `production` |
| `DEV_API_BASE_URL` | `https://dev-api.the-legion.example.com` | Dev base URL |
| `STAGING_API_BASE_URL` | `https://staging-api.the-legion.example.com` | Staging base URL |
| `API_BASE_URL` | `https://api.the-legion.example.com` | Production base URL |
| `API_TIMEOUT_SECONDS` | `30` | Connect/send/receive timeout |
| `ENABLE_NETWORK_LOGGING` | `true` | Request/response logging (forced off in production) |
| `USE_FAKE_DATA_SOURCES` | `true` outside production | In-memory fakes instead of the real API/storage |

### Working without an API (current phase)

The backend is not online yet, so **new work happens in the presentation
layer**. Two mechanisms keep the app fully runnable and demoable:

**1. `USE_FAKE_DATA_SOURCES` — fakes for the existing auth flow**

```text
USE_FAKE_DATA_SOURCES=true   (default in development/staging)
  AuthRemoteDataSource  → FakeAuthRemoteDataSource      (in-memory, simulated latency)
  AuthLocalDataSource   → InMemoryAuthLocalDataSource  (in-memory session)
USE_FAKE_DATA_SOURCES=false
  AuthRemoteDataSource  → AuthRemoteDataSourceImpl      (Dio)
  AuthLocalDataSource   → AuthLocalDataSourceImpl       (Hive + secure storage)
```

The repository, use cases, cubit and pages above the datasources are
**identical in both modes**, so nothing in the UI needs rewriting when the API
lands. Only `features/auth/di/auth_module.dart` picks the implementation.

A **production build always uses the real datasources** unless the flag is set
explicitly, so fakes cannot silently ship.

Demo credentials in fake mode: **any email + password `legion123`**
(`FakeAuthRemoteDataSource.defaultPassword`).

**2. Fixtures in `presentation/mock/` for new screens**

New features start as presentation only — no repository, no use case, no
datasource:

```text
features/<name>/presentation/
├── bloc/<name>_cubit.dart        # state transitions only
├── mock/<name>_fixtures.dart     # const sample data for the UI
├── pages/<name>_page.dart
└── widgets/
```

The cubit serves fixtures locally; pages never call anything but the cubit.
When the endpoint ships, the swap is: delete `mock/`, add the three
`data/` + `domain/` folders per the checklist in
[ARCHITECTURE.md](ARCHITECTURE.md), and have the cubit call the use case.

```bash
flutter run \
  --dart-define=ENVIRONMENT=staging \
  --dart-define=STAGING_API_BASE_URL=https://staging.example.com \
  --dart-define=ENABLE_NETWORK_LOGGING=false

flutter build web --release \
  --dart-define=ENVIRONMENT=production \
  --dart-define=API_BASE_URL=https://api.example.com
```

Values are resolved in `lib/core/config/app_config.dart` and read everywhere
through `sl<AppConfig>()`. **The placeholder URLs must be replaced with your
real endpoints** — otherwise every request fails with a network error by
design.

For release builds, inject real values from your CI secret store, e.g.:

```bash
export API_BASE_URL="$(vault read -field=api_base_url secret/the-legion)"
flutter build apk --release --dart-define=ENVIRONMENT=production \
  --dart-define=API_BASE_URL="$API_BASE_URL"
```

---

## Folder structure

```text
lib/
├── main.dart                  # bootstrap: bindings, DI, runApp
├── app.dart                   # root widget: theme, localization, router
│
├── core/                      # shared infrastructure, feature-agnostic
│   ├── config/                # AppConfig + Environment (compile-time config)
│   ├── constants/             # app-wide constants, storage box names
│   ├── di/                    # GetIt setup + per-area modules
│   ├── error/                 # exceptions, failures, mapping, localization
│   ├── extensions/            # BuildContext and String helpers
│   ├── l10n/                  # arb files + generated AppLocalizations
│   ├── network/               # Dio factory, interceptors, apiCall()
│   ├── router/                # GoRouter, route names, auth guard
│   ├── storage/               # KeyValueStore (Hive), SecureStorageService
│   ├── theme/                 # colors, typography, spacing, radii, theme
│   ├── utils/                 # AppLogger, breakpoints/responsive helpers
│   └── widgets/               # shared presentation widgets
│
└── features/
    ├── auth/                  # full Clean Architecture example
    │   ├── di/                # feature registrations
    │   ├── data/
    │   │   ├── datasources/{remote,local}/
    │   │   ├── models/
    │   │   └── repositories/
    │   ├── domain/
    │   │   ├── entities/
    │   │   ├── repositories/  # contracts (interfaces)
    │   │   └── usecases/
    │   └── presentation/
    │       ├── bloc/
    │       ├── pages/
    │       └── widgets/
    ├── home/                  # authenticated shell + overview (presentation)
    └── profile/               # session profile tab (presentation)
```

---

## Architecture in one minute

```text
UI (pages/widgets)
   ↓  BlocProvider / context.read
Cubit / Bloc (presentation)
   ↓  use case call
Use case (domain — business rules)
   ↓  repository contract
Repository implementation (data)
   ↓
Datasource (remote → Dio · local → Hive / secure storage)
```

Errors flow back along the same path, one type per layer:

```text
DioException → AppException (core/network/api_call.dart)
             → Failure       (translateToFailure in the repository)
             → state.failure (Cubit) → localized message (UI)
```

Raw `DioException` / `HiveError` objects never reach a widget.

See [`ARCHITECTURE.md`](ARCHITECTURE.md) for the rules, the dependency
direction and a checklist for adding a feature.

---

## Testing

```bash
flutter test
flutter test --coverage
```

Tests mirror `lib/`:

```text
test/
├── core/
│   ├── error/       # DioException mapping
│   ├── extensions/  # String helpers
│   ├── utils/       # breakpoints
│   └── widgets/     # shared widgets
├── features/<name>/ # mirrors lib/features/<name>/
└── policies/        # coding-policy enforcement (architecture_policies_test)
```

---

## Quality gates

```bash
dart format .
flutter analyze   # must report "No issues found!"
flutter test      # includes the coding-policy suite
```

---

## Platform notes

* **iOS** — `ios/Runner/{DebugProfile,Release}.entitlements` declare
  `keychain-access-groups`, which `flutter_secure_storage` requires; without
  them tokens silently fail to persist on iOS.
* **Web** — `flutter_secure_storage` only works on **HTTPS or localhost**
  (WebCrypto). Serve production web builds over HTTPS.
* **Web** — Hive stores data in IndexedDB; data is per-origin.
* **Bundle identifiers** — `com.example.the_legion_mobile` (Android) and
  `com.example.theLegionMobile` (iOS) are still placeholders; replace them with
  your organization's identifiers before shipping.
* No `Platform.isAndroid`-style checks exist in the app; platform differences
  are isolated behind storage/network abstractions.

---

## Project rules (do not break)

Every rule below is enforced by `test/policies/architecture_policies_test.dart`,
which runs as part of `flutter test`. See ARCHITECTURE.md §15 for the rationale.

**Architecture**

1. One state-management solution: BLoC/Cubit only.
2. Domain never imports Flutter, Dio, Hive or BLoC.
3. Presentation never touches Dio, Hive or a datasource.
4. Resolve dependencies through `sl`; do not `new` infrastructure in widgets.
5. No hardcoded API URLs — resolve them from the injected `AppConfig`.

**Design system**

6. No hardcoded colors, typography, spacing, padding, widths or heights — read
   `AppColors`, `AppTextStyles`, `AppSpacing`, `AppRadii` and `AppDimensions`.
   Color literals may only appear in `lib/core/theme/`.
7. No hardcoded user-facing strings — use `context.l10n`. Fixture content under
   `presentation/{mock,models,bloc}/` is exempt: it is data and state, not UI
   chrome.

**Structure**

8. Widgets are **public** classes in their feature's `presentation/widgets/`
   folder. No `class _Private extends StatelessWidget`, and no widget declared
   in a `pages/` file — a page composes widgets, it does not define them.

**Correctness and safety**

9. No `print`/`debugPrint` — use `AppLogger`.
10. Never log passwords, tokens or secrets (`redactPayload` exists for this).
11. No `Platform.isAndroid`-style checks in widgets — branch on the viewport.
12. Create a use case only when it carries a rule or a meaningful operation.