# Contract: Network Pipeline

Branch `001-phase0-project-foundation` · Spec `spec.md` · Plan `plan.md` · Model `data-model.md`

## Purpose

Defines the single standardized way every feature talks to the ShopSpace API (FR-004, SC-004, constitution §API conventions), so features never touch dio, the envelope, or raw errors.

## Endpoints (Phase 0 reference)

- Base URL: dev `http://localhost:3000` (SC-006; env-selected via `--dart-define`, `core/env/`).
- API prefix: `/api/v1` (Auth & User API, implementation plan).
- Response envelope: `{ message, status, data }`.

## Interceptor order (per request)

1. **Auth interceptor** — attaches `Authorization: Bearer <accessToken>` (from `TokenProvider`).
2. **Envelope interceptor** — unwraps `data` once on success (constitution §3); features receive typed data only.
3. **Retry/refresh interceptor** — on 401: exactly **one** silent refresh, retry once, then **force logout** (FR-006).
4. **Error interceptor** — maps non-2xx / dio errors to typed `Failure`s (`core/errors/`) via `ErrorMapper`; raw exceptions never reach UI (FR-005).
5. **Log interceptor** — dev/staging logging only (env-gated).

## Contract rules

1. **Envelope unwrapped exactly once** in `core/network/`. Feature code never sees `{message, status, data}`.
2. **No raw exceptions to UI.** All failures reach the UI as `Failure` types; `ErrorMapper` produces localized, user-friendly messages (never raw server text verbatim unless it is already user-safe).
3. **Single-flight 401 refresh:** concurrent 401s share one refresh future; a request retried once must not be retried twice (`RequestOptions.extra['retried']`).
4. **Session lifecycle signals:** `onTokensUpdated` persists the new pair (FR-007); `onSessionExpired` triggers router redirect to sign-in (FR-006). After password change, session cleared immediately (constitution §Roles — consumed Phase 1).
5. **Offline/5s:** request timeout + failure mapping; offline state shows shared `AppErrorView` with manual Retry (FR-009, SC-004). Recovery is user-triggered.
6. **`UnauthorizedFailure` is a domain state, not an error message** — drives the session-expired redirect.

## Owned by (files)

`lib/core/network/` (client + interceptors + token provider/refresher), `lib/core/errors/` (failures + mapper), `lib/core/storage/` (token storage).

## Consumed by

All features (Phases 1–6) via their repository interfaces — repositories are injected with dio-derived clients from `core/network`, never constructed by features.

## Verification (validation scenarios)

- Unauthorized request → one refresh + one retry succeeds; second consecutive 401 → sign-out + redirect.
- Envelope is never visible in any feature-level test or widget.
- Timeout/offline → typed failure → `AppErrorView` with Retry.
