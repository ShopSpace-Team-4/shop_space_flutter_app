---

description: "Task list for Phase 0 — Project Foundation, Design Tokens & Adaptive Shell"
---

# Tasks: Phase 0 — Project Foundation, Design Tokens & Adaptive Shell

**Input**: Design documents from `/specs/001-phase0-project-foundation/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/ (design-tokens.md, adaptive-shell.md, network-pipeline.md)

**Tests**: Included. Phase 0 explicitly requires unit (`test/unit/`), Cubit (`test/cubit/`), widget (`test/widget/`), and integration (`test/integration_test/`) coverage plus a `flutter analyze`-clean gate (plan → Testing; FR-012; constitution §7). Where practical, write a story's tests first and confirm they FAIL before implementing (TDD).

**Organization**: Tasks are grouped by user story so each story can be implemented and verified independently.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies on incomplete tasks)
- **[Story]**: Which user story this task belongs to (US1–US4)
- Include exact file paths in every description
- Repository root is `C:\rich_Sonic\shop_space_flutter_app`; all paths below are relative to it

## Environment Facts (from research.md — do not re-derive)

- Flutter 3.35.7 / Dart 3.9.2 at `C:\flutter`. **Always use `flutter`** (bare `C:\dart-sdk` is a different SDK).
- Pins (must stay — newer majors need Flutter �Y 3.38 / Dart �Y 3.10): `go_router` 17.2.3, `injectable_generator` 3.0.2, `build_runner` 2.15.1, `image_picker` 1.2.2.
- Codegen after model/DI edits: `dart run build_runner build --delete-conflicting-outputs`.
- l10n auto-generates on build via `generate: true` (manual: `flutter gen-l10n`); import from `package:flutter_gen/gen_l10n/app_localizations.dart`.
- Figma file `shop space ui` (id `pvU6vSwQkWqwT27HVS4Jcp`): Website section `7:12781`, Mobile App section `104:262` (all phone frames 375px wide → screenutil `designSize: Size(375, 812)`). Token extraction is node/style-based (decision D7) via Composio Figma MCP.

---

## Stage 1: Setup (Shared Infrastructure)

**Purpose**: Initialize the Flutter project at the repo root and lock the toolchain.

**⚠i�? CRITICAL**: Do not run `flutter analyze` / `flutter test` until `flutter create` has produced the scaffold (AGENTS.md).

- [x] T001 Create the Flutter project scaffold: run `flutter create --org com.shopspace --project-name shop_space --platforms ios,android .` from the repo root (generates `pubspec.yaml`, `analysis_options.yaml`, `lib/main.dart`, `test/widget_test.dart`, `android/`, `ios/`). Then DELETE the generated default `test/widget_test.dart` (references the removed counter app) and reset `lib/main.dart` to a minimal empty `runApp` placeholder (replaced in T027/T028).
- [x] T002 Write `pubspec.yaml` with `name: shop_space`, `description`, `publish_to: 'none'`, `environment: { sdk: ^3.9.2 }`, and `flutter: { generate: true }` (gen_l10n). Dependencies (pins from plan.md/research.md): `flutter_bloc` 9.1.1, `equatable` 2.1.0, `go_router` 17.2.3, `dio` 5.11.0, `get_it` 9.2.1, `injectable` 3.0.0, `freezed_annotation` 3.1.0, `json_annotation` (^4.9.0), `flutter_secure_storage` 10.3.1, `shared_preferences` 2.5.5, `flutter_screenutil` 5.9.3, `flutter_localizations` (sdk), `intl` 0.20.3, `image_picker` 1.2.2, `cached_network_image` 3.4.1, `url_launcher` 6.3.2, `google_sign_in` 7.2.0. Dev: `flutter_test` (sdk), `integration_test` (sdk), `flutter_lints`, `build_runner` 2.15.1, `injectable_generator` 3.0.2, `freezed` 3.2.5, `json_serializable` 6.14.1, `bloc_test` 10.0.0, `mocktail` 1.0.5.
- [x] T003 Create `l10n.yaml` at repo root: `arb-dir: lib/core/localization`, `template-arb-file: app_en.arb`, `output-class: AppLocalizations`, `nullable-getter: false`.
- [x] T004 Overwrite `analysis_options.yaml` with `include: package:flutter_lints/flutter.yaml` plus strict rules (e.g. `prefer_const_constructors`, `prefer_const_declarations`, `prefer_final_locals`, `avoid_print` where applicable). Keep it analyzer-clean from the start (FR-012).
- [x] T005 [P] Create the folder skeleton (empty dirs carry a `.gitkeep` so they are tracked): `lib/core/{env,di,router,network,errors,storage,theme,responsive,localization,widgets,utils}`, `lib/features/home/presentation`, and `test/{unit,cubit,widget,integration_test}`, plus `tool/`. Do NOT create feature folders for auth/user/listings/search/advisor/inquiries in Phase 0 (plan → Structure Decision).
- [x] T006 Run `flutter pub get`; confirm every pinned version resolves on Flutter 3.35.7 (bump nothing). If resolution fails, stop and flag (pins are deliberate — research.md §2).

**Checkpoint**: Scaffold exists, deps resolve, analyzer baseline configured.

---

## Stage 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST exist before ANY user story — every story consumes at least one of these.

**⚠i�? CRITICAL**: No user story work can begin until this phase is complete.

- [x] T007 [P] Implement `lib/core/env/app_env.dart`: `enum AppEnvironment { dev, staging, prod }` and `class AppEnv` (`AppEnvironment name`, `String apiBaseUrl`, `bool isLoggingEnabled`, `bool isRelease`) + `AppEnv.fromDartDefine()` reading `String.fromEnvironment('APP_ENV')`, defaulting to `dev`. Base URLs: dev/staging/prod → `https://shopspace-backend-production.up.railway.app` (final value confirmed via live verification). Logging: dev/staging `true`, prod `false` (data-model.md §3.1).
- [x] T008 [P] Implement `lib/core/errors/failures.dart`: `sealed class Failure { final String messageKey; }` with subclasses `NetworkFailure`, `TimeoutFailure`, `OfflineFailure`, `ServerFailure`, `UnauthorizedFailure`, `ValidationFailure` (data-model.md §4.2). All fields are localized message keys — never raw server text.
- [x] T009 [P] Implement `lib/core/responsive/window_size.dart`: `enum AppBreakpoint { compact, medium, expanded }` (`<600`, `600–839`, `>=840` dp) + `AppBreakpoint breakpointOf(BuildContext)` from `MediaQuery.sizeOf(context).width` (decision D4). Structure only — never scales values.
- [x] T010 [P] Implement `lib/core/storage/token_storage.dart`: plain `class AuthTokens { final String accessToken; final String refreshToken; }`, abstract `TokenStorage` interface (`Future<AuthTokens?> read()`, `write(AuthTokens)`, `clear()`) and `SecureTokenStorage` over `FlutterSecureStorage` (v10 — verify the `AndroidOptions` API, use `storageNamespace` for app isolation, Keychain on iOS; keys `auth.accessToken`, `auth.refreshToken`; decision D5). Used by `TokenProvider` (US2) and `addRole`/password-change flows in Phase 1 (constitution §6).
- [x] T011 [P] Implement `lib/core/storage/preferences_service.dart`: abstract `PreferencesService` (`getString`, `setString`, `removeString`) + impl over `SharedPreferencesAsync` (shared_preferences 2.5.5). Document the reserved keys `locale` and `activeRole` (data-model.md §5.2; constitution §6).
- [x] T012 [P] Set up DI in `lib/core/di/`: create `injectable.dart` with `@injectableInit` + `Future<void> configureDependencies() => getIt.init()` and `modules.dart` with `@module` registrations for `AppEnv` and the two storage services. Run `dart run build_runner build --delete-conflicting-outputs` to generate `lib/core/di/injectable_init.g.dart` (generated file — never hand-edit; re-run codegen after every DI/model change).

**Checkpoint**: Env, errors, breakpoints, storage, and DI exist and are generated. User story implementation can now begin.

---

## Stage 3: User Story 1 — App launches with correct branding on any device, in either language (Priority: P1) ?Y�� MVP

**Goal**: The app launches with the Figma-derived light theme, English + Arabic (RTL), an adaptive shell (bottom `NavigationBar` on compact, `NavigationRail` on medium/expanded), and a placeholder home screen. No feature flows yet.

**Independent Test**: Install on a phone and a tablet; launch in English and Arabic; verify the theme matches the approved brand, RTL mirrors, and the shell switches bottom-bar ↔ side-rail. Rotating/resizing across breakpoints must not break the layout or lose the selected destination (spec US1; quickstart §SC-007).

### Tests for User Story 1 (write first, confirm they FAIL before implementation)

- [x] T029 [P] [US1] Widget test `test/widget/app_adaptive_shell_test.dart`: at 360dp → `NavigationBar`; at 768dp → `NavigationRail`; at 1024dp (10.2�3 iPad landscape — FR-013 minimum tablet size) → extended `NavigationRail`; at 1280dp → extended `NavigationRail`; resizing between classes preserves the selected destination and content subtree (contracts/adaptive-shell.md).
- [x] T030 [P] [US1] Widget test `test/widget/shell_locale_rtl_test.dart`: shell renders at compact, medium AND expanded in both `en` and `ar` (incl. medium A� ar — constitution §7); assert localized labels change and directionality mirrors (`Directionality.rtl` for ar) with no overflow (FR-004, SC-001).
- [x] T031 [P] [US1] Cubit test `test/cubit/localization_cubit_test.dart` (flutter_test + mocktail — `bloc_test` unavailable on this SDK, decision D8): default `Locale('en')`; `setLocale('ar')` emits `Locale('ar')` and persists via `PreferencesService` (key `locale`); constructor loads the persisted locale on start.
- [x] T032 [P] [US1] Unit test `test/unit/theme_tokens_test.dart`: spot-check extracted token values (background `#F8FAFC` — the extracted `--bg-base`, not the older `#F5F5F5`, primary, heading font size) against the values recorded in T013; `AppTheme.build` produces a light-only `ThemeData` (brightness `Brightness.light`, SC-008).
- [x] T033 [P] [US1] Widget test `test/widget/home_placeholder_test.dart`: the placeholder home renders inside the shell with localized nav labels and token-derived styles; grep asserts no hardcoded user-facing strings (SC-002).

### Implementation for User Story 1

- [x] T013 [P] [US1] Extract design tokens from Figma via the Composio Figma MCP: call `FIGMA_GET_FILE_NODES` on file `pvU6vSwQkWqwT27HVS4Jcp` (`shop space ui`), inspecting Website section `7:12781` (style-guide boards first) and Mobile App section `104:262`; capture fill/paint colors, `TypeStyle` text nodes, `cornerRadius`, and `effects[]` (`DROP_SHADOW`) (research.md §7, decision D7). If a needed value is unavailable, **BLOCK + FLAG** — never invent (FR-002). Record the extracted values in `specs/001-phase0-project-foundation/contracts/design-tokens.md`.
- [x] T014 [P] [US1] Create `lib/core/theme/app_colors.dart`: `AppColors` const class with groups background/surface, text, accent/brand (`primary`, `primaryContainer`, `onPrimary`), semantic (`error`/`success`/`warning`/`info` + containers), and strokes (`outline`, `outlineVariant`) — values from T013 (data-model.md §1.1). Light-mode only.
- [x] T015 [P] [US1] Create `lib/core/theme/app_typography.dart`: `AppTypography` named styles (display, headline, title, body, label A� sizes) from T013 `TypeStyle` nodes (`fontFamily`, `fontSize`, `fontWeight`, `lineHeight`, `letterSpacing`, `textCase`) (data-model.md §1.2).
- [x] T016 [P] [US1] Create `lib/core/theme/app_spacing.dart`: `AppSpacing` named scale (`xs`, `sm`, `md`, `lg`, `xl`, `2xl`) from T013 frame spacing/padding values (data-model.md §1.3).
- [x] T017 [P] [US1] Create `lib/core/theme/app_radius.dart`: `AppRadius` named radii (`small`, `medium`, `large`, `pill`, `circular`) from T013 `cornerRadius` values (data-model.md §1.4).
- [x] T018 [P] [US1] Create `lib/core/theme/app_elevation.dart`: `AppElevation` named shadows (`none`, `low`, `medium`, `high`) from T013 shadow effects → `BoxShadow` (data-model.md §1.5).
- [x] T019 [US1] Create `lib/core/theme/app_theme.dart`: `AppTheme.build(BuildContext) → ThemeData` composing `AppColors`/`AppTypography`/`AppRadius`/`AppElevation` into a `ColorScheme` + `TextTheme`; single light theme only (SC-008). Depends on T014–T018.
- [x] T020 [P] [US1] Create `lib/core/localization/app_en.arb`: `@@locale: en`; externalize ALL Phase 0 chrome strings — app title, nav destination labels (Home, Profile, Listings, Search, Advisor, Inquiries), retry, coming-soon/placeholder copy, and any labels used by the shared states (US4). Zero hardcoded strings (SC-002).
- [x] T021 [P] [US1] Create `lib/core/localization/app_ar.arb`: `@@locale: ar`; complete Arabic translation for EVERY key in `app_en.arb` (no missing keys — verify with a key-set parity check: `flutter gen-l10n` must report zero untranslated-message warnings AND/OR a test asserting identical key sets across both ARB files).
- [x] T022 [US1] Create `lib/core/localization/localization_cubit.dart`: `LocalizationCubit` (Cubit<Locale>, default `Locale('en')`); `setLocale(Locale)` emits and persists via `PreferencesService` key `locale`; constructor loads persisted locale (data-model.md §5.2). Depends on T020/T021 + T011.
- [x] T023 [US1] Run `flutter gen-l10n` (auto-runs on build via `generate: true`) and verify `AppLocalizations` is importable with non-null getters (`nullable-getter: false`). Import path: `../localization/app_localizations.dart` from `core/` — gen_l10n emits next to the ARBs in `lib/core/localization/` (no synthetic package, decision D9), NOT `package:flutter_gen/...`.
- [x] T024 [US1] Create `lib/core/responsive/app_adaptive_shell.dart`: hand-rolled `AppAdaptiveShell` (decision D1, approved — replaces discontinued `flutter_adaptive_scaffold`): compact → Material `NavigationBar`; medium/expanded → `NavigationRail` (extended at expanded); preserves content state via `IndexedStack`; destinations list is an injectable hook (Phase 0 static placeholder list); RTL-safe — no hardcoded left/right (contracts/adaptive-shell.md).
- [x] T025 [P] [US1] Create `lib/features/home/presentation/home_screen.dart`: placeholder home screen rendered inside the shell using `Theme.of(context)` / token classes + localized strings (no magic numbers).
- [x] T026 [P] [US1] Create `lib/core/router/app_router.dart`: `AppRouter` (go_router 17.2.3) with the home route `/` → `AppAdaptiveShell` wrapping `HomeScreen`. Extended with placeholder routes in T050.
- [x] T027 [US1] Create `lib/bootstrap.dart`: `WidgetsFlutterBinding.ensureInitialized()`, `await configureDependencies()` (T012), instantiate `LocalizationCubit` (its constructor loads the persisted locale — T022; do NOT read the locale a second time here), wrap `MaterialApp` in `ScreenUtilInit(designSize: Size(375, 812))`; `MaterialApp` gets `theme: AppTheme.build(context)`, `locale`/`supportedLocales: [Locale('en'), Locale('ar')]` driven by `LocalizationCubit`, `localizationsDelegates` from `GlobalMaterialLocalizations`/`GlobalWidgetsLocalizations`/`GlobalCupertinoLocalizations`, and `AppRouter`. Depends on T019–T026.
- [x] T028 [US1] Update `lib/main.dart` to call the bootstrap and `runApp`.

**Checkpoint**: At this point, US1 should be fully functional and testable independently (app launches, themed, RTL, adaptive shell, home placeholder).

---

## Stage 4: User Story 2 — App talks to the backend through one reliable, consistent pipeline (Priority: P1)

**Goal**: A single standardized dio pipeline: auto-attach Bearer credentials, unwrap the `{ message, status, data }` envelope exactly once, map every failure to typed `Failure`s with localized messages, and perform exactly one silent 401 refresh + one retry, then a clean sign-out redirect (FR-005/006; constitution §3).

**Independent Test**: Against a stubbed backend (unit tests stub the dio base URL locally; the app itself targets `https://shopspace-backend-production.up.railway.app`): (1) a valid-session request attaches credentials automatically; (2) a business error surfaces a friendly localized message; (3) an expired session triggers ONE silent refresh + retry, and a second consecutive 401 clears the session and routes to sign-in. No raw `DioException`/technical error reaches the UI (spec US2).

### Tests for User Story 2

- [X] T045 [P] [US2] Unit test `test/unit/envelope_test.dart`: `ApiEnvelope.fromJson` parses `{ message, status, data }`; the envelope is only parsed inside `core/network/`.
- [X] T046 [P] [US2] Unit test `test/unit/auth_interceptor_test.dart` (mocktail `TokenProvider`): Bearer header attached for protected paths; NOT attached for the denylist (`auth/login`, `auth/signup`, `auth/refresh`, `auth/verify-otp`, `auth/resend-otp`, `auth/forgot-password`, `auth/reset-password`, `auth/google`) (research.md §4).
- [X] T047 [P] [US2] Unit test `test/unit/session_refresh_test.dart`: concurrent 401s share ONE refresh (single-flight `Completer`); the retried request is gated by `RequestOptions.extra['retried']` and never retried twice; refresh failure clears the session and emits the session-expired signal; the refresh+retry path resolves within the SC-004 5-second bound (assert via `Future.timeout(Duration(seconds: 5))` on the awaited response — upper-bound check, not latency measurement) (contracts/network-pipeline.md).
- [X] T048 [P] [US2] Unit test `test/unit/error_mapper_test.dart`: offline / timeout / non-2xx / 401 map to `OfflineFailure` / `TimeoutFailure` / `ServerFailure` / `UnauthorizedFailure` (etc.) with localized `messageKey`s — no raw exception propagates.

### Implementation for User Story 2

- [X] T034 [P] [US2] Create `lib/core/network/envelope.dart`: `class ApiEnvelope<T> { final String message; final String status; final T data; }` with `fromJson` (data-model.md §4.1). Parsed ONLY here.
- [X] T035 [P] [US2] Create `lib/core/network/token_provider.dart`: abstract `TokenProvider` (exposes current access token) + impl reading `TokenStorage`; `@injectable` so tests swap mocks.
- [X] T036 [P] [US2] Create `lib/core/network/token_refresher.dart`: refresh via a separate BARE `Dio` (no interceptors — no recursion) hitting `auth/refresh` with the refresh token; on success call `onTokensUpdated` to persist the new pair via `TokenStorage` (research.md §4).
- [X] T037 [P] [US2] Create `lib/core/errors/error_mapper.dart`: `ErrorMapper` mapping `DioException`/non-2xx → typed `Failure` with a localized `messageKey` (FR-005).
- [X] T038 [US2] Create `lib/core/network/interceptors/auth_interceptor.dart` (`onRequest`): attach `Authorization: Bearer <accessToken>` from `TokenProvider`, skipping the denylist above. Depends on T035.
- [X] T039 [US2] Create `lib/core/network/interceptors/envelope_interceptor.dart` (`onResponse`): unwrap `.data` once and surface it; non-2xx handled in error path, never unwrapped (contracts/network-pipeline.md). Depends on T034.
- [X] T040 [US2] Create `lib/core/network/interceptors/session_interceptor.dart` (`onError`): on 401 → single-flight shared refresh (one `Completer` for concurrent 401s), retry the original request once gated by `RequestOptions.extra['retried']`; on refresh failure clear session + emit `onSessionExpired` signal (router guard redirects to sign-in). Depends on T035/T036.
- [X] T041 [US2] Create `lib/core/network/interceptors/error_interceptor.dart` (`onError`): route every error through `ErrorMapper` so only typed `Failure`s propagate. Depends on T037.
- [X] T042 [P] [US2] Create `lib/core/network/interceptors/logging_interceptor.dart`: plain debug-print logging, active only when `AppEnv.isLoggingEnabled` (dev/staging).
- [X] T043 [US2] Create `lib/core/network/dio_client.dart`: `DioClient` factory building `Dio` with `baseUrl` from `AppEnv` (+ `/api/v1` prefix) and interceptors registered in order: auth → envelope → session/refresh → error → logging (contracts/network-pipeline.md). Depends on T038–T042.
- [X] T044 [US2] Register the network pipeline (`Dio`, interceptors, `TokenProvider`, `TokenRefresher`, session signals) in `lib/core/di/modules.dart`; re-run `dart run build_runner build --delete-conflicting-outputs`.

**Checkpoint**: US1 AND US2 both work independently (network pipeline fully covered by unit tests; app still launches offline via shared states from US4).

---

## Stage 5: User Story 3 — Developers start building features on a ready-made, consistent foundation (Priority: P2)

**Goal**: Standard developer paths: placeholder routes for every planned feature with auth/role guard mechanism, one standard DI registration path, dev/staging/prod build-time env selection, and a one-command quality gate (FR-008/009/010/012).

**Independent Test**: A trivial scaffold change passes `dart run tool/quality.dart`; a new service registers through the standard `@injectable`/build_runner path with no bespoke wiring; the app builds for each of the three environments via `--dart-define=APP_ENV` (spec US3; SC-006).

### Tests for User Story 3

- [ ] T053 [P] [US3] Unit test `test/unit/env_config_test.dart`: `AppEnv.fromDartDefine` maps `dev`/`staging`/`prod`; all three default to `https://shopspace-backend-production.up.railway.app`; `isLoggingEnabled` true for dev/staging, false for prod.
- [ ] T054 [P] [US3] Widget test `test/widget/unknown_route_test.dart`: navigating to an unknown route shows the graceful fallback (`errorBuilder`) — no crash (spec edge case).

### Implementation for User Story 3

- [ ] T049 [P] [US3] Create `lib/core/widgets/placeholder_screen.dart`: `AppPlaceholderScreen` (localized title, token-styled) for not-yet-implemented feature routes.
- [ ] T050 [US3] Extend `lib/core/router/app_router.dart`: add placeholder routes auth login/signup/otp/reset, user profile, listings, search, advisor, inquiries → `AppPlaceholderScreen` (�^8 placeholder routes total, plan → Scale/Scope); add `errorBuilder` graceful fallback for unknown routes. Depends on T049.
- [ ] T051 [US3] Create `lib/core/router/route_guards.dart`: `AuthGuard` + `RoleGuard` redirect logic against an injected session/roles reader interface (constitution §6: permission checks read `roles[]`, never `activeRole` alone); Phase 0 wires a default "no session / tenant-only" impl and documents the hook for Phase 1.
- [ ] T052 [P] [US3] Create `tool/quality.dart`: a Dart script that runs `flutter analyze` and `flutter test`, prints results, and exits non-zero on any failure (FR-012). Run via `dart run tool/quality.dart`.
- [ ] T055 [US3] Validation (CLI): register a trivial throwaway `@injectable` service through the standard DI path (T012 modules + build_runner) and confirm it resolves with no bespoke wiring, then remove it; build all three environments (`flutter build apk --debug --dart-define=APP_ENV=staging`, `...=prod`, and default dev) and confirm each succeeds (SC-006).

**Checkpoint**: US1, US2 AND US3 all work independently. Developer foundation is complete.

---

## Stage 6: User Story 4 — Sensitive credentials stored securely and survive app restarts (Priority: P3)

**Goal**: Verify the secure-storage foundation and ship shared, breakpoint-aware loading/error/empty states with a manual Retry (FR-007/011; spec US4).

**Independent Test**: The secure-storage wrapper (`TokenStorage`) and shared state widgets exist and are unit/widget-tested in Phase 0; credentials held in encrypted device storage (Keychain/Keystore), never plain text; shared states render consistently with the brand at compact and expanded (end-to-end restart persistence re-verified in Phase 1 once sign-in exists).

### Tests for User Story 4

- [X] T060 [P] [US4] Unit test `test/unit/token_storage_test.dart`: `SecureTokenStorage` read/write/clear round-trip against a mocktail-mocked `FlutterSecureStorage`; assert keys are namespaced (`auth.accessToken`, `auth.refreshToken`).
- [X] T061 [P] [US4] Unit test `test/unit/preferences_service_test.dart`: get/set/remove against a mocktail-mocked `SharedPreferencesAsync`; assert reserved keys (`locale`, `activeRole`) are used.
- [X] T062 [P] [US4] Widget test `test/widget/shared_states_test.dart`: `AppLoadingView`/`AppErrorView`/`AppEmptyView` render at compact AND expanded without overflow; `AppErrorView` Retry triggers its `onRetry` callback; the offline variant of `AppErrorView` renders a localized offline message with a working Retry (edge case: offline launch, since Phase 0 makes no network calls on startup) (FR-011).

### Implementation for User Story 4

- [X] T056 [P] [US4] Create `lib/core/widgets/app_loading_view.dart`: shared breakpoint-aware loading state using token-derived styles.
- [X] T057 [P] [US4] Create `lib/core/widgets/app_error_view.dart`: localized error/offline message + manual Retry action (`onRetry` callback); recovery is user-triggered (FR-011). Also renders the `UnauthorizedFailure`→sign-in redirect surface.
- [X] T058 [P] [US4] Create `lib/core/widgets/app_empty_view.dart`: shared empty state, token-styled and localized.
- [X] T059 [US4] Flag the gap: append a note to `specs/001-phase0-project-foundation/contracts/design-tokens.md` that Figma has no loading/error/empty frames and the shared states were built consistently from existing tokens (never invented — constitution §4, contracts gap-handling protocol).

**Checkpoint**: All four user stories are independently functional and tested.

---

## Stage 7: Polish & Cross-Cutting Concerns

**Purpose**: Cross-story integration verification, quality gate, and governance cleanup.

- [X] T063 Create `test/integration_test/app_launch_smoke_test.dart`: app-launch smoke at all three surface sizes (compact 360dp, medium 768dp, expanded 1280dp) × `en`/`ar` — asserts themed home renders inside the correct shell (`NavigationBar` vs `NavigationRail`) with no exceptions (SC-001, constitution §7).
- [X] T064 Run `dart run tool/quality.dart`: `flutter analyze` clean + ALL unit/cubit/widget/integration tests green (FR-012, SC-005). Fix any failures before moving on.
- [X] T065 [P] Update `AGENTS.md` → Repository status: the Flutter scaffold now exists (`pubspec.yaml`, `lib/`, tests), so `flutter analyze` / `flutter test` are allowed; point to this feature's `tasks.md` for Phase 0 status.

---

## Dependencies & Execution Order

### Stage Dependencies

- **Setup (Stage 1)**: No dependencies — starts immediately. **Blocks everything.**
- **Foundational (Stage 2)**: Depends on Setup. **Blocks ALL user stories** (env, errors, breakpoints, storage, DI).
- **User Stories (Stage 3+)**: All depend on Foundational completion.
  - US1 (T013–T033) and US2 (T034–T048) are both P1 and can proceed in parallel after Foundational.
  - US3 (T049–T055) after Foundational; T050 depends on T049.
  - US4 (T056–T062) after Foundational (its storage tests cover T010/T011 built in Stage 2).
- **Polish (Stage 7)**: Depends on all user stories being complete.

### User Story Dependencies

- **US1 (P1)**: No story dependencies. Needs Foundational (storage/prefs → locale persistence; DI → bootstrap).
- **US2 (P1)**: No story dependencies. Needs Foundational (env base URL; failures; `TokenStorage`; DI).
- **US3 (P2)**: No story dependencies. Needs Foundational (DI path; env).
- **US4 (P3)**: No story dependencies. Needs Foundational (storage wrappers T010/T011; breakpoint helper T009).

### Within Each User Story

- Write the story's tests first and confirm they FAIL before implementation (T029–T033, T045–T048, T053–T054, T060–T062).
- Tokens/model files before the components that consume them; interceptors before the `DioClient`; `DioClient` before DI registration.
- Story complete (its checkpoint) before moving to the next priority.

### Parallel Opportunities

- All `[P]` tasks are independent (different files, no uncompleted dependencies).
- Setup: T005 parallel with other setup steps where order allows.
- Foundational: T007–T011 fully parallel; T012 after T010/T011.
- US1: token classes T014–T018 after extraction T013, then parallel; ARB files T020/T021 parallel; bootstrap T027 after T019–T026; all five tests T029–T033 parallel.
- US2: T034–T037 parallel, then interceptors T038–T041 (after their deps), T042 parallel; T043 after T038–T042; T044 after T043; tests T045–T048 parallel.
- US3: T049/T052/T053/T054 parallel; T050 after T049.
- US4: T056/T057/T058 parallel; tests T060–T062 parallel.
- **US1 and US2 can be staffed by two developers in parallel** after Stage 2 (both P1).

### Parallel Example: User Story 1

```text
# Launch token extraction, then the five token-class files together:
Task: "Extract design tokens from Figma (Composio MCP)"
Task: "Create AppColors in lib/core/theme/app_colors.dart"
Task: "Create AppTypography in lib/core/theme/app_typography.dart"
Task: "Create AppSpacing in lib/core/theme/app_spacing.dart"
Task: "Create AppRadius in lib/core/theme/app_radius.dart"
Task: "Create AppElevation in lib/core/theme/app_elevation.dart"

# Then launch the five US1 tests together:
Task: "Widget test test/widget/app_adaptive_shell_test.dart"
Task: "Widget test test/widget/shell_locale_rtl_test.dart"
Task: "Cubit test test/cubit/localization_cubit_test.dart"
Task: "Unit test test/unit/theme_tokens_test.dart"
Task: "Widget test test/widget/home_placeholder_test.dart"
```

### Parallel Example: User Story 2

```text
# Launch the four independent leaf files together:
Task: "Create envelope.dart in lib/core/network/envelope.dart"
Task: "Create token_provider.dart in lib/core/network/token_provider.dart"
Task: "Create token_refresher.dart in lib/core/network/token_refresher.dart"
Task: "Create error_mapper.dart in lib/core/errors/error_mapper.dart"

# Then the four tests together:
Task: "Unit test test/unit/envelope_test.dart"
Task: "Unit test test/unit/auth_interceptor_test.dart"
Task: "Unit test test/unit/session_refresh_test.dart"
Task: "Unit test test/unit/error_mapper_test.dart"
```

---

## Implementation Strategy

### MVP First (P1 stories only)

1. Complete Stage 1: Setup.
2. Complete Stage 2: Foundational (CRITICAL — blocks all stories).
3. Complete US1 (Stage 3) → **STOP and VALIDATE**: launch phone + tablet, EN + AR, RTL, shell bar↔rail, rotation.
4. Complete US2 (Stage 4) → **STOP and VALIDATE** the three network paths (valid session / business error / expired session).
5. Demo-ready foundation: theme + shell + l10n + network pipeline.

### Incremental Delivery

1. Setup + Foundational → foundation ready.
2. Add US1 → test independently → demo (app launches branded, RTL, adaptive).
3. Add US2 → test independently → network plumbing proven.
4. Add US3 → test independently → developer foundation proven.
5. Add US4 → test independently → shared states + storage verified.
6. Polish: integration smoke + quality gate + AGENTS.md update.

### Parallel Team Strategy

With multiple developers after Foundational:
- Developer A: US1 (theme + l10n + shell) — P1
- Developer B: US2 (network pipeline) — P1
- Then Developer C: US3; Developer D: US4.
- US1 and US2 touch disjoint files (`core/theme`+`core/localization`+`core/responsive` vs `core/network`+`core/errors`) — no file conflicts.

---

## Notes

- `[P]` = different files, no dependencies. `[Story]` = traceability to spec.md stories.
- Pins in pubspec.yaml (T002) are deliberate — do not upgrade (`go_router` 17.2.3, `injectable_generator` 3.0.2, `build_runner` 2.15.1, `image_picker` 1.2.2).
- `flutter_adaptive_scaffold` is NOT used — hand-rolled `AppAdaptiveShell` (decision D1, user-approved 2026-08-05).
- Never invent design tokens (FR-002); if a token/state frame is missing, build consistently from existing tokens and flag the gap (T013, T059).
- Run `dart run build_runner build --delete-conflicting-outputs` after any model/DI edit; `flutter gen-l10n` runs automatically on build.
- Verify tests fail before implementing each story (TDD gate).
- Commit after each task or logical group; stop at any checkpoint to validate the story independently.
- Avoid: vague tasks, same-file conflicts, cross-story dependencies that break independence.
