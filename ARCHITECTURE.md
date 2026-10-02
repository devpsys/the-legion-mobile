# Architecture

This document describes **why** the code in `lib/` is shaped the way it is, and
the rules a change must respect.

---

## 1. Goals

* **Predictable dependencies.** A layer may only depend on the layer below it.
* **Testable business logic.** Use cases and repositories are plain Dart and can
  be unit tested without Flutter bindings, Dio or Hive.
* **Framework-swappable.** Swapping Dio for `http`, or Bloc for another state
  container, must not touch the domain layer.
* **Feature ownership.** Everything specific to a feature lives inside
  `features/<name>/`; only genuinely shared infrastructure goes to `core/`.

---

## 2. Layers and dependency direction

```text
┌──────────────────────────────────────────────┐
│ presentation   pages, widgets, cubit/bloc    │  Flutter, go_router, l10n
├──────────────────────────────────────────────┤  depends on ↓
│ domain         entities, usecases,          │  pure Dart only
│                repository contracts          │  (equatable is allowed)
├──────────────────────────────────────────────┤  implemented by ↓
│ data           models, datasources,          │  Dio, Hive, secure storage
│                repository implementations    │
└──────────────────────────────────────────────┘
```

Rules:

1. `domain/` must not import `package:flutter/**`, `dio`, `hive_ce`,
   `flutter_bloc`, `go_router` or any `data/` file. It may import `equatable`
   and pure-Dart `core/error` value objects.
2. `data/` may import `domain/` (it implements its contracts) and `core/`.
3. `presentation/` may import `domain/` and `core/`, never `data/`.
4. `core/` never imports from `features/` **except** the composition roots:
   `core/router/app_router.dart` (must reference concrete pages),
   `core/di/injection.dart` and `core/di/router_module.dart` (wire the
   container). Anything else `core/` needs from a feature is exposed as an
   interface declared in `core` (see `AuthGuard`, `AuthTokenProvider`), so the
   networking and routing infrastructure stays feature-agnostic.

### Verified dependency rules

```bash
# Domain must be framework-free:
grep -rn "package:flutter\|package:dio\|package:hive\|package:flutter_bloc" \
  lib/features/*/domain        # → no matches allowed

# Presentation must not talk to datasources:
grep -rn "datasources/\|DataSource" lib/features/*/presentation   # → no matches
```

---

## 3. Error handling

One type per layer, converted exactly once:

| Layer | Type | Purpose |
| --- | --- | --- |
| transport | `DioException` | never escapes `core/network` |
| data | `AppException` | thrown by datasources |
| data → domain | `Failure` | thrown by repositories, read by cubits |
| presentation | `AuthState.failure` + `Failure.localize(l10n)` | user-facing copy |

* `core/network/api_call.dart` wraps every request and maps `DioException` →
  `AppException` via `DioExceptionMapper`.
* `core/error/failure_translator.dart` (`translateToFailure`) wraps repository
  bodies and maps `AppException`, `DioException`, `HiveError` and anything
  unexpected → `Failure`.
* Failure subclasses: `ServerFailure`, `NetworkFailure`, `AuthFailure`,
  `ValidationFailure`, `CacheFailure`, `UnexpectedFailure`.
* `ValidationFailure` carries a machine-readable `ValidationCode`; the UI maps
  it to a localized string in `core/error/failure_localization.dart`. The
  domain therefore never depends on Flutter's localization code.

---

## 4. State management

* One Cubit/Bloc per feature area; `AuthCubit` owns the session for the whole
  app and is registered as a **singleton** because the router and multiple pages
  observe it.
* States are immutable, `Equatable`-based and modelled with a **status enum**
  (`AuthStatus`) rather than `isLoading` / `hasError` / `isSuccess` booleans,
  which can represent illegal combinations.
* A Cubit only calls use cases. A use case only calls a repository. A widget
  only calls a cubit.

### Router ↔ state bridge

`core/router/router_refresh_notifier.dart` adapts the cubit stream to GoRouter's
`refreshListenable`, and the redirect logic in `core/router/app_router.dart`
reads `AuthGuard`:

```text
session unknown      → redirect to /  (splash)
!isAuthenticated     → redirect to /login
isAuthenticated + /login → redirect to /home
```

Deep links (`/home`, `/home/profile`, `/login`) therefore behave the same on
Android, iOS and the web, including browser refresh and back gestures.

---

## 5. Dependency injection

`lib/core/di/injection.dart` exposes the service locator as `sl` and composes
area modules:

```text
configureDependencies()
├── registerStorageModule()   // Hive box + secure storage   (async)
├── registerNetworkModule()   // the single Dio instance
├── registerAuthModule()      // features/auth/di/auth_module.dart
├── registerRouterModule()    // GoRouter
└── configureLogging()        // silence in production
```

* Register infrastructure once; register repositories as **factories** (new
  instance per use) and cubits as **lazy singletons** when their state must be
  shared.
* Feature modules live in `features/<name>/di/`, keeping `core/di` free of
  feature imports.
* Nothing in `presentation/` may call `Dio()`, `Hive.initFlutter()`,
  `FlutterSecureStorage()` or a repository constructor directly.

---

## 6. Networking

* One `Dio` instance, built by `core/network/dio_client.dart` from `AppConfig`
  (base URL, timeouts, JSON headers).
* Interceptors:
  * `AuthInterceptor` — attaches `Authorization: Bearer …` from
    `AuthTokenProvider`, and clears the session on `401` (skipped when the
    request sets `extra: {AuthInterceptor.skipAuth: true}`).
  * `LoggingInterceptor` — dev only, masks credentials via `redactPayload`.
* Endpoints live in the feature datasource (`AuthRemoteDataSourceImpl.loginPath`),
  always relative to the configured base URL.

---

## 7. Storage

| Data | Where | Why |
| --- | --- | --- |
| Access/refresh tokens | `flutter_secure_storage` | credentials |
| Cached user profile | Hive (`KeyValueStore`) | non-sensitive cache |

`KeyValueStore` is an interface, so feature datasources are testable with a
fake. Cache entries are JSON encoded by the model layer, which keeps the cache
portable across mobile files and web IndexedDB.

Hive is only reached through `HiveKeyValueStore`; `HiveError` is converted to
`CacheFailure` at the repository boundary.

---

## 8. Design system

| Token file | Contents |
| --- | --- |
| `core/theme/app_colors.dart` | brand/neutral/error tokens, light & dark schemes (add status tokens when a feature needs them) |
| `core/theme/app_text_styles.dart` | type scale and weights |
| `core/theme/app_spacing.dart` | spacing scale, page/card padding, gap helpers |
| `core/theme/app_radii.dart` | corner radius scale |
| `core/utils/responsive.dart` | `AppDimensions`: breakpoints and max widths |
| `core/theme/app_theme.dart` | `ThemeData` assembled from the tokens |

Widgets read the ambient theme through `core/extensions/context_extensions.dart`:

```dart
context.theme · context.colors · context.textStyles · context.l10n
context.screenSize · context.isCompact · context.viewport
```

When a design specification arrives, update these files — do not introduce
one-off styles inside screens.

---

## 9. Responsive layout

| Bucket | Width | Navigation | Content |
| --- | --- | --- | --- |
| `compact` | < 600 | `NavigationBar` | full width |
| `medium` | 600–839 | `NavigationBar` | full width |
| `expanded` | 840–1439 | `NavigationRail` | constrained by `ResponsiveContent` |
| `large` | ≥ 1440 | `NavigationRail` | constrained, wide shell |

`AdaptiveScaffold` (core) renders one of the two navigation chromes, so phones,
tablets and web share a single page implementation. Layout reacts to the
viewport, never to `Platform`, and only reads `MediaQuery` — which keeps Android,
iOS and Web consistent.

---

## 10. Localization

* Source of truth: `lib/core/l10n/arb/app_en.arb`.
* Generated classes live in `lib/core/l10n/gen/` (`flutter gen-l10n`,
  configured by `l10n.yaml`, `nullable-getter: false`).
* Widgets use `context.l10n.*`; failures use `failure.localize(context.l10n)`.
* Adding a language: copy the arb file (`app_es.arb`), translate, run
  `flutter gen-l10n`. No UI change needed.

---

## 11. Logging

`core/utils/app_logger.dart` wraps the `logger` package:

* `AppLogger.instance.d/i/w/e(...)` instead of `print`.
* `AppLogger.silence()` is applied automatically for
  `Environment.production`.
* Never log passwords or tokens. `redactPayload` / `redactHeaders` mask
  credential keys (`authorization`, `password`, `*Token`, `secret`, `apiKey`)
  before output; the logging interceptor applies them automatically.

---

## 12. Testing

```text
test/
├── core/
│   ├── error/        # pure mapping logic
│   ├── extensions/
│   ├── utils/
│   └── widgets/      # widget tests with an injected MediaQuery
└── features/auth/
    ├── data/         # repository + mocked datasources (mocktail)
    ├── domain/       # use case validation, no Flutter needed
    └── presentation/ # cubit transitions (bloc_test)
```

Guidelines:

* Mock **interfaces** (`AuthRepository`, `AuthRemoteDataSource`,
  `AuthLocalDataSource`), never concrete classes.
* Domain tests must run without `TestWidgetsFlutterBinding`.
* Register `registerFallbackValue` for non-nullable custom types used with
  `any()`.
* `core/di` is not exercised by unit tests: tests construct the object under
  test directly, which is exactly why dependencies are injected.

---

## 13. Adding a feature

> **Current phase:** the backend is not online. Start every feature as
> **presentation only** (step 0) and complete steps 1–3 when the endpoints
> exist. See "Working without an API" in the README for the fake switch.

0. **Presentation first** — `presentation/{bloc,pages,widgets,mock}`. Fixtures
   in `presentation/mock/<name>_fixtures.dart` are served by the cubit. This is
   a legitimate temporary state, not a shortcut: page, widgets, state model,
   theme usage and localization are final code.
1. **Create the folder** `lib/features/<name>/{data,domain,presentation}` —
   only the sub-folders you actually need.
2. **Domain first**: entities (immutable, `Equatable`), repository contract,
   use cases that encode real rules.
3. **Data**: models with explicit `fromJson`/`toJson`, remote datasource using
   the injected `Dio` and `apiCall()`, local datasource using `KeyValueStore` /
   `SecureStorageService`, repository impl wrapped in `translateToFailure`.
4. **Presentation**: one cubit/bloc per stateful area with a status enum,
   pages that only compose widgets, widgets that only read state.
5. **Register dependencies** in `lib/features/<name>/di/<name>_module.dart` and
   call it from `core/di/injection.dart`.
6. **Route**: add paths to `core/router/route_names.dart` and the route to
   `core/router/app_router.dart`; navigate with `context.goNamed(...)`.
7. **Strings**: add keys to `app_en.arb`, then `flutter gen-l10n`.
8. **Styling**: use the tokens; add new tokens to `core/theme` only when the
   value is reused or is a genuine design decision.
9. **Tests**: use case, repository, cubit — mirroring `features/auth` in
   `test/`.

### Copy/paste starting point

```text
features/<name>/
├── di/<name>_module.dart
├── data/
│   ├── datasources/
│   │   ├── remote/<name>_remote_data_source.dart
│   │   ├── local/<name>_local_data_source.dart
│   │   └── fake/                     # only while the API is pending
│   ├── models/<entity>_model.dart
│   └── repositories/<name>_repository_impl.dart
├── domain/
│   ├── entities/<entity>.dart
│   ├── repositories/<name>_repository.dart
│   └── usecases/<verb>_<entity>.dart
└── presentation/
    ├── bloc/<name>_cubit.dart · <name>_state.dart
    ├── mock/<name>_fixtures.dart     # only while the API is pending
    ├── pages/<name>_page.dart
    └── widgets/
```

### Test-data strategy (no API yet)

Prefer fakes over mock-framework ceremony while the backend is pending:

```text
data/datasources/fake/
├── fake_<name>_remote_data_source.dart      # simulates latency + failures
└── in_memory_<name>_local_data_source.dart  # fields instead of Hive
```

A fake implements the **same datasource interface** as the real one, so the
repository, use cases and cubit are production-identical; only the DI module
chooses which implementation is bound (see `AppConfig.useFakeDataSources`).

Once the API is online: delete `data/datasources/fake/`, drop the flag, and keep
the fake tests — they still describe the expected contract.

---

## 14. Anti-patterns rejected in review

| Anti-pattern | Why it is rejected |
| --- | --- |
| `getUser()` usecase that only forwards one call | indirection without value; call the repository's use case only when it carries a rule |
| Repository returning `Map<String, dynamic>` | loses type safety; use a model |
| Widget calling a repository or datasource | untestable business logic in the view |
| `isLoading`/`hasError`/`isSuccess` flags | permits impossible states; use a status enum |
| Widget-local `Colors.x`, `EdgeInsets.all(16)`, `TextStyle(...)` | design decisions belong in the design system |
| `print('error: $e')` | no level, no redaction, no testability |
| `if (Platform.isAndroid)` inside a widget | layout should be driven by the viewport |
| `Dio()` inside a datasource | duplicate networking configuration and lost interceptors |
| Global `models/`, `services/`, `screens/` folders | no ownership; scales badly |