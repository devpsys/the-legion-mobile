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
└── features/auth/
    ├── data/        # repository with mocked datasources
    ├── domain/      # use case validation
    └── presentation/# cubit transitions with bloc_test
```

---

## Quality gates

```bash
dart format .
flutter analyze   # must report "No issues found!"
flutter test
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

1. One state-management solution: BLoC/Cubit only.
2. Domain never imports Flutter, Dio, Hive or BLoC.
3. Presentation never touches Dio, Hive or a datasource.
4. No hardcoded API URLs — inject `AppConfig`.
5. No hardcoded colors, typography, spacing or radii — use the design system in
   `core/theme`.
6. No hardcoded user-facing strings — use `context.l10n`.
7. No `print`/`debugPrint` — use `AppLogger`.
8. Never log passwords, tokens or secrets (`redactPayload` exists for this).
9. Resolve dependencies through `sl`; do not `new` infrastructure in widgets.
10. Create a use case only when it carries a rule or a meaningful operation.