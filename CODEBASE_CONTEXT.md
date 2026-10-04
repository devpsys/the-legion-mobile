# Codebase context

Practical briefing for future work in this repository. Authoritative rules
live in [ARCHITECTURE.md](ARCHITECTURE.md) and [README.md](README.md); this
file is the short map. It describes the working tree as of the onboarding
review, including uncommitted admissions-outcome work that is not on `main`.

## Purpose and stack

The Legion is a multi-platform university portal (Android, iOS, Web). The
app today covers sign-in, account recovery, a student landing hub, a thin
profile tab, and a candidate admissions portal. Fees, registration, two-factor
sign-in, and most hub modules are not built.

| Concern | Choice |
| --- | --- |
| Language / SDK | Dart 3.13.5, Flutter 3.47.6 (stable) |
| Package | `the_legion_mobile` |
| State | `flutter_bloc` Cubits, `Equatable` states, status enums |
| Navigation | `go_router` |
| DI | `get_it` as `sl` |
| HTTP | one `Dio` client |
| Cache / secrets | `hive_ce` via `KeyValueStore`; `flutter_secure_storage` for tokens |
| i18n | `flutter gen-l10n`, source `lib/core/l10n/arb/app_en.arb` |
| Tests | `flutter_test`, `bloc_test`, `mocktail` |

Visual source of truth: Institutional Sovereign in
`ui-designs/design-system/institutional_sovereign/DESIGN.md`. That folder is
gitignored (`.gitignore` `/ui-designs/`), so it exists on disk and is not in
history. Tokens in code: `lib/core/theme/` and `AppDimensions` in
`lib/core/utils/responsive.dart`.

## Architecture

Feature-based Clean Architecture. Dependency direction is
presentation → domain → data, with `core/` shared and feature-agnostic.

```text
lib/
├── main.dart, app.dart          # bootstrap, theme, l10n, router, session
├── core/                        # config, di, error, network, router, storage, theme, widgets
└── features/
    ├── auth/                    # full data + domain + presentation (the template)
    ├── password_recovery/       # domain policy + presentation; no data layer
    ├── home/                    # presentation only; fixtures read in the scaffold
    ├── profile/                 # presentation only; renders AuthCubit.user
    └── admissions/              # presentation only; cubit serves fixtures
```

`main` calls `configureDependencies()` then `runApp(TheLegionApp)`.
`TheLegionApp` provides `AuthCubit` and `NotificationCubit` above
`MaterialApp.router`.

**Current phase (README):** the backend is not online. New features start as
presentation only. Auth is the exception: it already has the full stack, and
`AppConfig.useFakeDataSources` (default on outside production) binds in-memory
fakes. A production build uses the real datasources unless
`USE_FAKE_DATA_SOURCES` is set explicitly.

Composition roots that may import features: `core/di/injection.dart`,
`core/di/router_module.dart`, `core/router/app_router.dart`. Everything else in
`core/` stays feature-agnostic via ports (`AuthGuard`, `AuthTokenProvider`).

## Mandatory policies

Enforced by `test/policies/architecture_policies_test.dart` (part of
`flutter test`) plus `analysis_options.yaml`:

1. BLoC/Cubit only. Status enums, not `isLoading` / `hasError` / `isSuccess`.
2. `domain/` imports no Flutter, Dio, Hive, or BLoC.
3. `presentation/` never imports Dio, Hive, or a datasource.
4. Widgets resolve dependencies through `sl` or an ancestor provider. Do not
   construct `Dio`, Hive, or repositories in widgets.
5. No hardcoded API URLs. Read `sl<AppConfig>()`.
6. No colour, type, spacing, padding, width, or height literals in
   presentation UI. Use `AppColors`, `AppTextStyles`, `AppSpacing`,
   `AppRadii`, `AppDimensions`. Colour literals only in `lib/core/theme/`.
7. No user-facing string literals in presentation UI. Use `context.l10n`.
   `presentation/{bloc,mock,models}/` may hold fixture content.
8. Every widget is a public class. Pages compose widgets; widget classes live
   in `presentation/widgets/`. A page file may declare the page (and its
   public `State`).
9. Log with `AppLogger`, never `print` / `debugPrint`. Never log passwords,
   tokens, or secrets.
10. Branch layout on the viewport (`context.viewport`), never `Platform`.
11. Add a use case only when it encodes a rule. A pass-through use case is
    rejected.
12. Navigate with `context.goNamed(Routes.*Name)` / `pushNamed`. Paths live in
    `lib/core/router/route_names.dart`.
13. Money is integer kobo, formatted with `formatNaira` (`lib/core/utils/money.dart`).
    Dates go through `AppDateFormats` (`lib/core/utils/dates.dart`), day-first
    like the designs (`14 Sep 2026`); presentation code does not call
    `DateFormat` directly.
14. Sentence case. All-caps only for acronyms (JAMB, CGPA, NUC). Inter for
    prose, JetBrains Mono for identifiers, dates, and currency. No gradients,
    glows, or emoji. Depth is a 1px hairline, not a shadow.
15. Single quotes, `prefer_final_*`, `always_declare_return_types`,
    `directives_ordering`. `unawaited_futures` is an error.

`flutter analyze` must report no issues. Formatter: `dart format .`.

## How to extend a feature

While the API is pending, follow admissions, not a new style:

```text
features/<name>/
├── di/<name>_module.dart                 # register from core/di/injection.dart
└── presentation/
    ├── bloc/<name>_cubit.dart            # status enum; serves fixtures
    ├── bloc/<name>_state.dart
    ├── mock/<name>_fixtures.dart         # delete when the API exists
    ├── models/<view_model>.dart          # screen shapes, not API DTOs
    ├── pages/<name>_page.dart            # composition only
    └── widgets/<widget>.dart             # public widgets
```

The cubit is the only reader of fixtures. Pages call the cubit. Widgets read
state and call cubit methods or navigation. Taps with no service yet call
`context.showMessage(context.l10n.commonComingSoon)`.

When an endpoint exists, copy `features/auth`:

- Domain entity (`Equatable`), repository contract, use case with a real rule.
- Model with explicit `fromJson` / `toJson`.
- Remote datasource uses the injected `Dio` and `apiCall()`.
- Local datasource uses `KeyValueStore` / `SecureStorageService`.
- Repository wraps the body in `translateToFailure`.
- Errors: `DioException` → `AppException` → `Failure` → `failure.localize(l10n)`.
  Widgets never see `DioException` or `HiveError`.
- Register in `features/<name>/di/<name>_module.dart`.
- Prefer a fake datasource behind `useFakeDataSources` over mock-framework
  ceremony. Mock interfaces in tests, never concrete classes.

Representative files:

| Pattern | File |
| --- | --- |
| Full feature DI + fake switch | `lib/features/auth/di/auth_module.dart` |
| Use case with validation | `lib/features/auth/domain/usecases/login.dart` |
| Repository + failure translation | `lib/features/auth/data/repositories/auth_repository_impl.dart` |
| Remote call | `lib/features/auth/data/datasources/remote/auth_remote_data_source.dart` |
| Session cubit | `lib/features/auth/presentation/bloc/auth_cubit.dart` |
| Presentation-only cubit | `lib/features/admissions/presentation/bloc/admissions_cubit.dart` |
| Domain rule without a repository | `lib/features/password_recovery/domain/entities/password_policy.dart` |
| Router + auth redirect | `lib/core/router/app_router.dart` (`resolveRedirect`) |
| Shared chrome | `lib/core/widgets/adaptive_scaffold.dart`, `notification_bell.dart` |

Home is the older fixture style: `HubScaffold` reads `HubFixtures` directly
and has no cubit. Do not copy that for new features. ARCHITECTURE.md §13 says
the cubit serves the fixtures.

Draft application edits (choices, declaration) live in
`ApplicationDetailBodyState`, not the cubit, until they are saved. That is
intentional local UI state.

## Routes

| Path | Screen | Who |
| --- | --- | --- |
| `/` | splash, then redirect | unresolved session |
| `/login` | sign-in | anonymous |
| `/forgot-password` … `/success` | recovery, one cubit via `ShellRoute` | anonymous only |
| `/home`, `/home/profile` | student shell (`StatefulShellRoute`) | authenticated |
| `/admissions`, `/programmes`, `/applications`, `/applications/:id` | candidate portal, one `AdmissionsCubit` | authenticated |

`resolveRedirect` sends unresolved sessions to splash, anonymous users to
login (recovery stays public), and authenticated users off splash, login, and
recovery onto `/home`. New portal paths must be covered by `Routes` or they
bypass the session check. Back for the portal is `AdmissionsShell` /
`admissionsBackTarget`, not a nested `PopScope`.

There is no role model. Any signed-in user can open the student hub and the
candidate portal.

## Feature status

| Feature | Status | Notes |
| --- | --- | --- |
| Sign-in, lockout, session restore, sign-out | Partially implemented | Full layers. Default build uses fakes. Real client is `POST /auth/login` only. |
| Remember me, create account, verify letter, registry contact | UI only | Buttons show `commonComingSoon`. |
| Two-factor, email confirmation flows | Not implemented | Designed under `ui-designs/auth/`, no screens. |
| Password recovery | Mocked | Four screens, real `PasswordPolicy`, fake code in `RecoveryRules`. No datasource. |
| Student hub | Mocked | Timeline, directory, announcements from `HubFixtures`. Only Admissions and Profile navigate. |
| Profile | Partially implemented | Session email, name, sign-out. Not a designed profile product. |
| Notifications | Mocked | `NotificationCubit` singleton fed by `NotificationFixtures`. Mark-read is in memory. |
| Admissions overview, programmes, applications | Mocked | Cubit + fixtures. Search, faculty, and cycle selection are local. Apply and bulletins are `commonComingSoon`; the claim card and the JAMB tab open the claim screen. |
| JAMB claim (`/admissions/jamb`) | Mocked | `JambClaimCubit` matches the typed facts against `AdmissionsFixtures.jambImport`; `AdmissionsCubit.linkJambResult` puts the match on the record, clears the badge and ticks the draft's checklist row. Help link is coming soon. |
| Application detail (draft) | Mocked | Checklist, choices, referees, submit, withdraw sheet render. Saves, invites, submit, and withdraw report coming soon. |
| Offer, rejection, expired, withdrawn, matriculated | Mocked, uncommitted | Working tree only (not on `main`). UI is wired; accept, decline, letters, and help desk are coming soon. Navigation to programmes and `/home` is real. |
| Submitted, under review, accepted, declined detail | UI only | History card only. `ApplicationOutcomeSections` says those designs do not exist yet. |
| Admission letter, public verification (`/verify/admission`) | Mocked | Letter drawn from the record's `AdmissionLetter`; verification looks codes up in `AdmissionsFixtures.verificationRegister`, no session. |
| Referee form | Not implemented | Design exists locally. |
| Fees and payments, results, timetable, other hub modules | Not implemented | Fees designs exist locally under `ui-designs/fees/`. No Dart feature. |
| Bursary officer | Not implemented | Not designed in this checkout. |

Demo auth credentials are documented in README.md under "Working without an
API". Do not treat them as production secrets, and do not copy them into new
docs.

## Data, config, and integrations

Compile-time only, via `--dart-define`, resolved in
`lib/core/config/app_config.dart`:

| Define | Default |
| --- | --- |
| `ENVIRONMENT` | `development` |
| `DEV_API_BASE_URL` / `STAGING_API_BASE_URL` / `API_BASE_URL` | `*.the-legion.example.com` placeholders |
| `API_TIMEOUT_SECONDS` | `30` |
| `ENABLE_NETWORK_LOGGING` | `true`, forced off in production |
| `USE_FAKE_DATA_SOURCES` | on outside production unless set |

No `.env`, no checked-in secrets, no CI workflow, no OpenAPI spec in this
repo. Placeholder base URLs fail by design until replaced at build time.

Networking: `createDio` → `LoggingInterceptor` (dev) → `AuthInterceptor`
(Bearer token; `extra.skipAuth` for login; 401 calls `onUnauthorized`, which
clears local tokens). There is no refresh-token exchange. Logout clears local
storage only; it does not call the API.

Storage: access and refresh tokens in secure storage; cached user JSON in
Hive box `app_cache`. Hive is reached only through `HiveKeyValueStore`.

Bundle ids are still placeholders: `com.example.the_legion_mobile` (Android)
and `com.example.theLegionMobile` (iOS).

## Known constraints

- README's folder tree omits admissions, password recovery, and notifications.
  ARCHITECTURE.md §4's redirect table omits recovery and the portal. The code
  and `resolveRedirect`'s own comment are the current behavior.
- `ui-designs/` READMEs still list some admissions screens as missing that the
  working tree now draws (offer, closed states, application detail). Trust the
  code for implementation status; trust the design READMEs for screens that
  have no Dart feature.
- Product briefs referenced as `../../thelegion/docs/stitch-*.md` are outside
  this repository.
- Closed programmes stay visible. "Not tracked" is a third checklist state,
  not a failure, and does not block submission.
- Offer expired is warning/amber. `offered` displays as "Admission offered".
- Outstanding balance and wallet balance must never be combined (fees design
  rule; fees are not built).
- Public verification and public receipt check must not show contact or
  identity fields beyond what their design READMEs allow.
- Widget tests inject `now` so dates stay deterministic. Follow that when a
  screen depends on the clock.
- `AdmissionsCubit` and `PasswordRecoveryCubit` are factories. `AuthCubit` and
  `NotificationCubit` are singletons.

## Commands verified on this tree

```bash
flutter analyze    # No issues found
flutter test       # All tests passed (412)
```

Toolchain confirmed: Flutter 3.47.6, Dart 3.13.5. `flutter gen-l10n` runs on
`flutter pub get` (`generate: true`). No device or browser run was part of
the review. No CI config exists to re-check.

## Uncommitted work

`main` matches `origin/main` at the application-detail commit. The working
tree adds offer, rejection, closed-state, and matriculation UI
(`application_outcome_sections.dart` and the new cards), fixture records for
those statuses, ARB strings, and `application_outcomes_test.dart`. Do not
revert or restyle that work while implementing something else.

## Before changing code

1. Read ARCHITECTURE.md §13–§15 and the closest feature above.
2. Reuse tokens, `context.l10n`, `Routes`, `formatNaira`, `Failure.localize`,
   and shared widgets.
3. Do not add a dependency, a second state library, or a data layer before
   an endpoint exists.
4. Keep pages thin. Put widgets in `presentation/widgets/`.
5. Add or update tests beside the change, including a policy-safe layout.
6. Run `flutter analyze` and the relevant `flutter test` targets.
7. If a request conflicts with these rules, say so and take the smallest
   compliant path.
