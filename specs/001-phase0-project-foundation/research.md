# Phase 0 Research — Project Foundation, Design Tokens & Adaptive Shell

Branch `001-phase0-project-foundation` · Date 2026-08-05 · Spec `specs/001-phase0-project-foundation/spec.md`

## 1. Environment

- **Flutter**: 3.35.7 stable (Dart 3.9.2) at `C:\flutter`. Bare `C:\dart-sdk` is a DIFFERENT SDK — always use the `flutter` tool.
- **Targets**: iOS + Android only (spec assumption). Local run devices available for manual checks: Windows desktop, Chrome, Edge (no emulator currently connected — tablet verification is via size-class widget tests + configurable test surfaces).
- **Git**: branch `001-phase0-project-foundation`; repo has no `pubspec.yaml` yet (Phase 0 scaffolds it).

## 2. Package versions (Flutter 3.35.7 / Dart 3.9.2)

> Why pins: the newest majors of four packages require Flutter ≥ 3.38 / Dart ≥ 3.10 (both newer than the installed 3.35.7 / 3.9.2). Pin these at the newest version that resolves on 3.35.7.

### Pinned (newer majors need a newer SDK)
| Package | Pin | Why not latest |
|---|---|---|
| `go_router` | **17.2.3** | 18.x requires Dart ≥ 3.10 |
| `injectable_generator` | **3.0.2** | 3.1.x requires SDK ≥ 3.10 |
| `build_runner` | **2.15.1** | 3.0 requires Dart ≥ 3.10 |
| `image_picker` | **1.2.2** | 1.3.x requires Flutter ≥ 3.38 |

### Latest, verified OK on 3.35.7
`flutter_bloc` 9.1.1 · `equatable` 2.1.0 · `dio` 5.11.0 · `get_it` 9.2.1 · `injectable` 3.0.0 · `freezed` 3.2.5 · `freezed_annotation` 3.1.0 · `json_serializable` 6.14.1 · `flutter_secure_storage` 10.3.1 · `shared_preferences` 2.5.5 (requires Flutter ≥ 3.35 — OK) · `flutter_screenutil` 5.9.3 · `intl` 0.20.3 · `cached_network_image` 3.4.1 · `url_launcher` 6.3.2 · `google_sign_in` 7.2.0 · `bloc_test` 10.0.0 (matches bloc ^9) · `mocktail` 1.0.5 · `integration_test` (SDK) · `flutter_localizations` (SDK).

### Responsive package status (decision D1)
`flutter_adaptive_scaffold` **0.3.3+1** — the latest release — is **discontinued upstream**: deprecated Feb 2025, package archived (flutter/flutter#162965). Keeping it means shipping a dead dependency. **Decision (flagged, requires approval)**: do NOT use it; hand-roll a thin `AppAdaptiveShell` in `core/` that switches Material's built-in `NavigationBar` (compact) ↔ `NavigationRail` (medium/expanded) using our own breakpoint helper. Zero new packages; removes an unmaintained dep. This is a deviation from the locked stack (§8 — flagged below).

## 3. Localization — English + Arabic, RTL day-one (decision D2)

**Chosen: built-in `flutter_localizations` + `intl` via `gen_l10n` (ARB).** The constitution allows either `easy_localization` or `intl`/`flutter_localizations`; picked the built-in route.

- `pubspec.yaml`: `generate: true`; deps `flutter_localizations` (sdk), `intl`; `flutter: { generate: true }`.
- `l10n.yaml` at repo root: `arb-dir: lib/core/localization`, `template-arb-file: app_en.arb`, `output-class: AppLocalizations`, `output-dir` synthetic (default), `nullable-getter: false` (avoid `!` everywhere).
- ARB files: `app_en.arb` (source), `app_ar.arb` (Arabic). All strings externalized from the first line — zero hardcoded user-facing strings (SC-002).
- Runtime switching: `LocalizationCubit` (Cubit `Locale`, default `en`) persisted to `shared_preferences`; `MaterialApp.locale` driven from it; `supportedLocales: [Locale('en'), Locale('ar')]`, `localizationsDelegates` from `GlobalMaterialLocalizations` etc. RTL mirroring is automatic via Flutter (SC/FR-004).
- Rejected `easy_localization`: third-party runtime parser + asset overlay; the gen_l10n toolchain is the Flutter-standard path and fully testable.

## 4. Networking pipeline — one standardized dio path (FR-005/006)

Single shared `Dio` client. **Interceptor order matters:**

1. `LoggingInterceptor` (dev builds only — plain debug print, satisfies "no dedicated logging" clarification).
2. `AuthInterceptor` (`onRequest`: attach `Authorization: Bearer <accessToken>`; **denylist** of unauthenticated endpoints: `auth/login`, `auth/signup`, `auth/refresh`, `auth/verify-otp`, `auth/resend-otp`, `auth/forgot-password`, `auth/reset-password`, `auth/google`).
3. `EnvelopeInterceptor` (`onResponse`: unwrap the `{ message, status, data }` envelope ONCE and pass `data` up; surface `message`/`status` for failure mapping — features never parse the envelope).
4. `RetryInterceptor` (optional, for timeouts/5xx only).

**401 handling (single silent refresh):**
- A single-flight shared refresh future (`Completer`) so concurrent 401s trigger one refresh.
- The original request is retried once, gated by `RequestOptions.extra['retried']` (flag) to avoid infinite recursion.
- Refresh uses a **separate bare `Dio`** (no auth interceptor, no envelope/retry recursion) hitting `auth/refresh`.
- Refresh failure → clear secure-storage session + emit a session-expired signal → router guard redirects to sign-in. No raw exception reaches the UI.

**Wiring (injected):** `TokenProvider` (reads access token), `TokenRefresher` (bare-Dio refresh), `onTokensUpdated` (persist new pair), `onSessionExpired` (clear + redirect). All injected via `get_it` so Phase 0 tests swap mocks (mocktail).

**Error mapping (FR-005):** non-2xx / `DioException` → typed `Failure` classes in `core/errors/` (`NetworkFailure`, `ServerFailure`, `UnauthorizedFailure`, `ValidationFailure`, `OfflineFailure`, …) mapped ONCE in the dio layer; features render only localized friendly messages (spec clarification: no dedicated logging).

**Env/base:** dev base URL `http://localhost:3000`; all endpoints `/api/v1` (constitution §3).

## 5. Responsive strategy (FR-003/013)

Two different jobs, two different tools (constitution §1):

- **Value scaling** → `flutter_screenutil` 5.9.3. Reference frame = Figma phone frames: all Mobile-App frames are **375 logical px wide** (dominant height 812). → `ScreenUtilInit(designSize: Size(375, 812))`, then `.w/.h/.sp/.r`.
- **Layout structure** → Material 3 window-size classes via a local helper (decision D4): compact < 600dp, medium 600–839dp, expanded ≥ 840dp. Implemented in `core/responsive/window_size.dart` as `enum AppBreakpoint { compact, medium, expanded }` + `breakpointOf(context)` using `MediaQuery.sizeOf(context).width` (constitution-safe: no new package; the `window_size_classes` package was rejected).
- Shell switches `NavigationBar` (compact) ↔ `NavigationRail` (medium/expanded) — see decision D1.
- Verified at all three breakpoints × both locales; 10"+ tablet = the expanded class minimum (FR-013).

## 6. Storage (FR-007)

- **Tokens**: `flutter_secure_storage` 10.3.1. v10 is a breaking major vs 9.x: `AndroidOptions(encryptedSharedPreferences: …)` was removed in v10 — **verify the exact v10 `AndroidOptions` API at implementation time** and use `storageNamespace` for app isolation. iOS uses Keychain.
- **Non-sensitive prefs** (locale, `activeRole`): `shared_preferences` 2.5.5 — prefer the newer `SharedPreferencesAsync` API.
- Wrap both in `core/storage/` (`TokenStorage`, `PreferencesService`) so Phase 1 consumes abstractions, and Phase 0 can unit-test them.
- `addRole` → replace stored token pair immediately; password change → clear session + route to login (constitution §6 — consumed in Phase 1).

## 7. Figma token sourcing (FR-002) — VERIFIED reachable, node-based extraction

- File **`shop space ui`** (`pvU6vSwQkWqwT27HVS4Jcp`), last modified 2026-08-04, role `viewer`. Connection works via Composio Figma MCP.
- Structure: canvas **Design System** → sections **Website** (7:12781, 21505×17452) and **Mobile App** (104:262). Mobile App holds 10 phone frames, ALL **375 wide**: Splash 375×812, On Boarding 375×812, On Boarding -2, On Boarding -3, Login (all 375×812), Sign up 375×924, Home 375×1000, Search 375×840, Property 375×654, AI Space Advisor 375×802 — plus a design-components `Section 1` (status-bar sets using published color styles `colors/backgrounds/light` = `#F5F5F5`, `colors/backgrounds/dark` = `#0F0F0F`).
- **Token extraction method**: `FIGMA_EXTRACT_DESIGN_TOKENS` returned **0 tokens** (colors/typography/spacing/border_radius/shadows empty) because variables extraction requires `file_variables:read` scope, which the current connection lacks. The file DOES publish styles (see the two color styles above), so values are available in **node fills / type styles**.
  - **Approach**: extract tokens from nodes via `FIGMA_GET_FILE_NODES` (per-frame fills, text style nodes, corner radius, effects) at the START of Phase 1's token work; the `Website` section is the likely home of the style-guide boards — inspect it first. If a needed token value is truly unavailable, **block + flag** (FR-002 / constitution §4) — never invent.

## 8. Decisions log

| ID | Decision | Status |
|----|----------|--------|
| D1 | Replace discontinued `flutter_adaptive_scaffold` with hand-rolled `AppAdaptiveShell` (NavigationBar↔NavigationRail via breakpoint helper) | **FLAGGED — needs approval** (constitution §8 deviation) |
| D2 | Localization via built-in `gen_l10n` (flutter_localizations + intl), not `easy_localization` | Decided (allowed by constitution) |
| D3 | screenutil `designSize = Size(375, 812)` from Figma Mobile App frames | Decided |
| D4 | Size classes via `MediaQuery.sizeOf` helper in `core/responsive/`; `window_size_classes` package rejected | Decided |
| D5 | `flutter_secure_storage` 10.x `AndroidOptions` API — verify at implementation | Open (verify) |
| D6 | Package pins for Flutter 3.35.7: `go_router` 17.2.3, `injectable_generator` 3.0.2, `build_runner` 2.15.1, `image_picker` 1.2.2 | Decided |
| D7 | Token extraction is node/style-based (variables scope missing) | Decided — no blocker (styles are published) |
| D8 | `bloc_test` **dropped for Phase 0 Cubit tests** — hard toolchain incompatibility: pinned `build_runner` 2.15.1 requires `analyzer >=8.0.0 <14.0.0`, but every `test`/`bloc_test` release caps `analyzer <8.0.0` while `flutter_test` pins `test_api 0.7.6`; no resolution exists on this SDK. Cubit tests use `flutter_test` + `mocktail` (manual stream assertions). Constitution §Testing deviation — **FLAGGED**. | FLAGGED — needs approval |
| D9 | gen_l10n generated output lands in `lib/core/localization/` (l10n.yaml has no `synthetic-package`/`output-dir`, so files are emitted next to the ARBs and imported via `../localization/app_localizations.dart`) | Decided — verified by build + tests |
