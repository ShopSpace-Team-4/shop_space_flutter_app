# Data Model — Phase 0 (Project Foundation)

Branch `001-phase0-project-foundation` · Date 2026-08-05 · Spec `spec.md` · Plan `plan.md`

Covers the data structures Phase 0 introduces, per the spec's **Key Entities**: **Design Token**, **Stored Session Credentials**, **Environment Configuration** — plus the transport/error shapes the network pipeline owns. All models are plain/freezed Dart under `lib/core/` (no `domain/` entities — constitution §2).

## 1. Design Token

Single named design value, extracted once from the `shop-space-ui` Figma file (node/style-based, decision D7), centralized in `lib/core/theme/`, referenced app-wide. Never re-derived per screen.

### 1.1 Color tokens — `AppColors`

| Token group | Field | Figma source |
|---|---|---|
| Background | `backgroundLight`, `backgroundDark`, `surface` | styles `colors/backgrounds/light` (extracted `--bg-base` `#F8FAFC` — see contracts/design-tokens.md; not the older `#F5F5F5`), `colors/backgrounds/dark` (#0F0F0F), `Surface` |
| Text | `textPrimary`, `textSecondary`, `textOnAccent` | typography/color nodes in Website style boards |
| Accent/brand | `primary`, `primaryContainer`, `onPrimary` | brand color swatch |
| Semantic | `error`, `success`, `warning`, `info` (+ containers) | state frames |
| Strokes/borders | `outline`, `outlineVariant` | input/border frames |

Rules: alpha is kept in `Color` values; each token is a single source of truth. Values are light-mode only (SC-008) — no dark palette built.

### 1.2 Typography — `AppTypography`

Named text styles extracted from the Figma type style nodes (`TypeStyle`: `fontFamily`, `fontSize`, `fontWeight`, `lineHeight`, `letterSpacing`, `textCase`). Exposed as the scale: `display`, `headline`, `title`, `body`, `label` × sizes. Converted into the Material `TextTheme` in `AppTheme`. Arabic uses the same scale (letter-spacing/null adjustments handled by Flutter RTL).

### 1.3 Spacing — `AppSpacing`

Numeric scale (e.g. `xs, sm, md, lg, xl, 2xl`) extracted from frame spacing/padding values. Used via `flutter_screenutil` (`.r`) so values scale proportionally; never inline magic numbers.

### 1.4 Corner radius — `AppRadius`

Named radii (`small, medium, large, pill, circular`) from frame `cornerRadius` values; applied via `BorderRadius`.

### 1.5 Elevation — `AppElevation`

Named shadows (`none, low, medium, high`) from Figma `effects[]` (shadow type: `DROP_SHADOW`) → Material elevation/`BoxShadow`.

### 1.6 Model shape (Dart)

```dart
// lib/core/theme/app_colors.dart etc. — plain classes (not freezed; no (de)serialization needed).
class AppColors { final Color primary; const AppColors({...}); }
```

No JSON transport for tokens — they are compiled constants. `AppTheme.build(BuildContext) → ThemeData` composes `AppColors`/`AppTypography`/`AppRadius`/`AppElevation` into a single light `ThemeData` (SC-008).

## 2. Stored Session Credentials

The signed-in user's token pair, held in **secure device storage** (FR-007). Created in Phase 0 (wrapper + tests), consumed in Phase 1.

### 2.1 Model

```dart
// lib/core/storage/token_storage.dart
class AuthTokens {
  final String accessToken;
  final String refreshToken;
  const AuthTokens({required this.accessToken, required this.refreshToken});
}
```

Fields persisted via `flutter_secure_storage` (Keychain/Keystore), keys namespaced (`auth.accessToken`, `auth.refreshToken`).

### 2.2 Contract

`TokenStorage` interface (`read/write/clear`) — consumed by the network pipeline's `TokenProvider`/`onTokensUpdated`/`onSessionExpired`. Semantics required by Phase 1 (constitution §6): `addRole` replaces the stored pair immediately; password change clears the session. Plain `{ message, status, data }`-independent — no envelope involvement.

## 3. Environment Configuration

Named config per target environment, selected at build time via `--dart-define` (FR-008, decision set in constitution §1).

### 3.1 Model

```dart
// lib/core/env/app_env.dart
enum AppEnvironment { dev, staging, prod }
class AppEnv {
  final AppEnvironment name;
  final String apiBaseUrl;   // dev → http://localhost:3000
  final bool isLoggingEnabled; // dev/staging true, prod false
  final bool isRelease;
  const AppEnv({...});
  static AppEnv fromDartDefine(String value); // via String.fromEnvironment
}
```

Dev defaults to the local backend. Single build-time switch — SC-006 (all three environments build/run).

## 4. Network transport shapes (owned by `core/network/`)

### 4.1 Response envelope

```dart
// lib/core/network/envelope.dart — parsed ONLY here (constitution §3)
class ApiEnvelope<T> { final String message; final String status; final T data; }
```

`EnvelopeInterceptor` unwraps `.data` once in `onResponse`; features never parse the envelope. Non-2xx is handled in `onError`, never treated as a successful unwrap.

### 4.2 Typed failures

```dart
// lib/core/errors/failures.dart
sealed class Failure { final String messageKey; } // localized, never raw
class NetworkFailure   extends Failure {}
class TimeoutFailure   extends Failure {}
class OfflineFailure   extends Failure {}
class ServerFailure    extends Failure {}
class UnauthorizedFailure extends Failure {}   // → session-expired path
class ValidationFailure extends Failure {}
```

Mapped once in `ErrorMapper` (dio layer). Raw exceptions/`DioException` never reach the UI (FR-005).

### 4.3 Refresh flow state

`SessionState` signal emitted by the pipeline: `SessionExpired` → router guard redirects to sign-in (FR-006). Single-flight refresh future shared across concurrent 401s; `RequestOptions.extra['retried']` gates the one retry.

## 5. Cross-cutting shared models

### 5.1 Breakpoint

```dart
// lib/core/responsive/window_size.dart
enum AppBreakpoint { compact, medium, expanded }  // <600, 600–839, ≥840 dp
```

Derived from `MediaQuery.sizeOf(context).width` — drives shell/layout structure only (decision D4).

### 5.2 Locale

`Locale` (Dart built-in); `LocalizationCubit` holds current `Locale`, persists to `shared_preferences` (key `locale`), default `en`. `supportedLocales = [en, ar]`.

## 6. Anti-patterns to avoid

- No `domain/` entities or DTO→entity mapping (same models flow through all layers).
- No design-token JSON loading at runtime — tokens are compiled constants from Figma (source-of-truth) extraction.
- No envelope parsing outside `core/network/`.
- No raw `DioException`/platform errors surfacing to widgets.
