# Research: Auth Verification & Roles (Phase 1)

Feature `002-auth-verification-roles` · Branch `002-auth-verification-roles` · Plan `plan.md`

## Scope

Deliver unauthenticated auth flows (signup → OTP, login, Google sign-in, forgot/reset password)
in `features/auth/` and session-scoped account/role management (profile, password change, roles,
activeRole switch, become landlord) in `features/user/`, wired into the Phase 0 router guards,
session controller, and dio pipeline.

## Resolved Decisions

### D1 — Google sign-in: `google_sign_in` 7.x integration pattern

**Decision**: Use the singleton `GoogleSignIn.instance` flow:
`initialize()` (awaited exactly once at DI bootstrap, configured with `serverClientId`) →
`signIn()`/`signOut()` → on success read `account.authentication.idToken` and POST it to
`/auth/google`.

**Rationale**:
- 7.x made the instance a true singleton and requires `initialize()` before any other call;
  centralizing it in `AuthGoogleService.init()` avoids the "not initialized" / double-init errors.
- Dart-side `serverClientId` (Android) and `clientId` take precedence over plist values, so the
  web client ID (for `/auth/google`) is passed programmatically — this is the correct Android
  setup when `google-services.json` is not present.
- `authenticate()` returns tokens synchronously from the cached account, so a full re-signIn on
  every launch is unnecessary; call it lazily when an idToken is needed.
- iOS requires the reversed-client-ID in `CFBundleURLTypes`; captured as a platform-config task.

**Alternatives rejected**:
- One-shot `signIn()` returning the account directly (works, but couples the Cubit to the plugin
  and re-auths every launch; the service seam keeps the Cubit testable with mocktail).
- Redirecting through `/auth/google` with a system browser — violates the single-app-flow and the
  ID-token contract in the finalized API.

**Collision handling**: A 409 (email already exists with a password account) must be surfaced as a
localized message guiding the user to password sign-in. It is **not** a Google-cancel; both cases
are distinguished by typed `Failure` variants (`GoogleSignInCancelled`, `EmailAlreadyRegistered`).

### D2 — OTP input & cooldown UX

**Decision**: One real `TextFormField` (digits-only, `maxLength 6`, `keyboardType: number`) visually
overlaid by six display boxes; the real field carries a single screen-reader label and the boxes are
`ExcludeSemantics`-wrapped. Resend is a countdown button backed by a Cubit-held absolute deadline
(`resendCooldownUntil = now + 60s`); the widget owns a `Timer.periodic(1s)` canceled in `dispose()`.

**Rationale**:
- A single real field gives reliable autofill/paste, native keyboard, and one clear semantics label;
  six real fields break screen readers and complicate paste handling.
- Cubit-owned absolute deadline (not a widget-owned counter) survives rebuilds and keeps tests
  deterministic (`resendCooldownUntil` asserted without real timers).
- 5-attempt cap and reset-on-new-code live in the Cubit state machine, so the counter can't be
  bypassed by navigating.

**Alternatives rejected**:
- Six separate `TextFormField`s (screen-reader noise, paste fragmentation).
- Widget-local `Timer` countdown only (state lost on rebuild, non-testable).
- Native SMS retriever plugin — not in the locked dependency list; the app is a generic OTP entry,
  not Android-only SMS autofill.

### D3 — Session hydration on launch

**Decision**: On cold start, `AuthSessionCubit.initialize()` reads the stored access token
(`flutter_secure_storage`). If present, it treats the session as authenticated, fires
`GET /users/me` in the background to hydrate `User` (roles, activeRole, isVerified), and lets the
router's `AuthGuard` unblock immediately. Any 401 from `/users/me` flows through the existing
single-refresh-then-logout pipeline. If no token, the session is unauthenticated and `/login` shows.

**Rationale**:
- Matches the Phase 0 `DefaultSessionReader` seam (`SessionReader.isAuthenticated`) and the
  "one silent refresh, then force logout" rule — no new session machinery.
- Hydrating `/users/me` in the background (not blocking navigation) avoids a flash of logout for
  valid sessions while still catching expired tokens fast.
- `activeRole` is read from the hydrated user (server truth); `shared_preferences` is only a
  fallback the moment the dashboard shell renders before `/users/me` resolves.

**Alternatives rejected**:
- Blocking startup on `/users/me` before showing the shell (adds a permanent spinner to every
  launch; Phase 0 settled on a non-blocking `AppLoadingView` on splash).
- Trusting only the stored token with no hydration (stale roles/permissions until next call —
  violates "permission-sensitive UI reads roles[]" freshness).

### D4 — Validation rules (Egyptian phone, password)

**Decision**:
- Phone: normalize client-side to international `+20` form. Accept digit-only or `01x`-prefixed
  Egyptian formats in the input, canonicalize to `+2<0x...>` (`+201000000000`). No punctuation.
- Password: min 8 chars, must contain ≥1 letter and ≥1 digit (Q2). Same rule on signup and
  change-password; no composition rules beyond that.
- OTP: exactly 6 digits, digits-only.

**Rationale**: Mirrors the finalized spec clarifications (Q1/Q2) and keeps the API payloads in the
canonical `+20` format the backend expects. Client-side cap (5 attempts, Q4) is in the OTP Cubit.

**Alternatives rejected**:
- Storing the raw `01x` form (backend expects `+20` canonical; the server API table shows
  `phone` used verbatim for OTP/WhatsApp).
- Arbitrary additional password rules (uppercase/symbol) — not in spec, would block users for no
  stated security reason.

### D5 — Figma fidelity approach & documented gaps

**Decision**: Reuse the Phase 0 token surface (`AppColors`, `AppTypography`, `AppSpacing`,
`AppRadius`, `AppElevation`) — verified to match the extracted Login/Sign up frames exactly
(primary `#2563EB`, text `#0F172A`, labels `#64748B`, hints/inactive `#94A3B8`, track `#F1F5F9`,
stroke `#E2E8F0`, pill radii, primary-CTA shadow `rgba(37,99,235,0.30) blur 16 y4` ≈ high elevation).
Screen-specific structure (field order, copy, CTA) pulled from `Login` `95:2932` and `Sign up`
`95:3094`. No new tokens are invented.

**Documented gaps (flagged per Phase 0 gap-handling protocol)**:
- No Figma frame for **OTP/verify, forgot/reset password, or profile/roles**. These screens are
  built from the same tokens and the auth component patterns (segmented toggle, labeled inputs,
  pill CTA, divider + social buttons) that Login/Sign up establish.
- The `Sign up` frame's field list (email, first name, last name, phone, **otp**) omits a password
  field and inlines an OTP field. The finalized API requires `password` at signup and a separate
  `/auth/verify` step, so the signup form = first/last name, email, phone, password (+confirm) and
  OTP is its own screen. Flagged as an intentional deviation driven by the API contract.
- Inputs in the design are `cornerRadius 8`; the Phase 0 scale has `small 6` / `medium 10`. The
  auth inputs reuse `AppRadius.medium (10)` to stay on the locked scale (never invent values).

**Alternatives rejected**:
- Introducing a bespoke auth-only radius value (violates "no invented values" and the locked scale).
- Copying the Sign up frame verbatim (would ship a passwordless signup — contradicts the API).

### D6 — Session-scoped account management seam

**Decision**: `user/` feature owns profile, password change, roles, activeRole switch, and become
landlord. `UserRepository` (one interface, one impl) is injected into both the `user/` Cubits and
any future feature (e.g. Become a Landlord) via get_it — per the cross-feature reuse rule.
`addRole` result returns a fresh token pair; the auth token storage is updated **immediately**
(old access token may not carry the new role).

**Rationale**: Matches the session-boundary split (auth = unauthenticated + token lifecycle,
user = behind valid session) and the "never duplicate role logic" rule.

**Alternatives rejected**: Duplicating role logic in each screen (constitution forbids it); adding a
third `roles/` feature (session-boundary rule keeps it under `user/`).

## Open items (non-blocking)

- Exact Figma node values for the segmented toggle's active-pill shadow and text weights were
  captured from the frames; any fine weight/size deltas beyond the token table are resolved by the
  token classes at implementation time, no re-extraction.
