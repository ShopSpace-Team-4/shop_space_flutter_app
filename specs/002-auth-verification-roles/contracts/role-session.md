# Contract: Roles & Session Lifecycle

Branch `002-auth-verification-roles` · Research D3/D6 · Plan `plan.md`

## Purpose

Defines how `features/user/` manages roles/activeRole and how token replacement + session clearing
behave, per constitution §6 (Roles & Sessions) and §3 (API conventions).

## Roles

- Every account defaults to `tenant`. `landlord` is added only via the shared
  `UserRepository.addRole('landlord')` (→ `POST /users/me/roles`). No other code path adds roles.
- Accounts may hold both roles; `roles[]` (from `GET /users/me`) is the full, authoritative set.
- **Permission-sensitive UI reads `roles[]`, never `activeRole` alone.** `activeRole` only decides
  which dashboard shell renders.

## activeRole

- `PATCH /users/me/active-role { role }` persists server-side; response `User.activeRole` becomes
  truth.
- Mirrored to `shared_preferences` (key `activeRole`) so the app reopens on the last-used
  dashboard before `/users/me` hydrates (D3). On hydration, server value wins.
- Switching activeRole re-renders the `AppAdaptiveShell` (bottom nav ↔ nav rail) — it never
  changes `roles[]` and never triggers re-login.

## addRole → token replacement (mandatory ordering)

```
UserRepository.addRole('landlord')
  → POST /users/me/roles
  → RoleChangeResponse { tokens, user }
  → 1) TokenStorage.write(tokens)          // BEFORE any UI reflects roles[]
  → 2) emit user with roles += landlord
```

The old access token may lack the new role's permissions — the stored pair **must** be replaced
immediately. Cubits never cache the pre-`addRole` token.

## Password change → session clear (no waiting for 401)

```
PUT /users/me/password { currentPassword, newPassword }  → success
  → 1) TokenStorage.clear()
  → 2) AuthSessionCubit → unauthenticated
  → 3) navigate to /login (replace, no back stack)
```

The app must not wait for a 401 from the backend before dropping the session.

## Google & logout

- Local logout: `AuthGoogleService.signOut()` (if the account signed in via Google) then
  `POST /auth/logout` (best-effort) then clear tokens + session → `/login`.
- `POST /auth/logout` bumps the token version server-side; the refresh token is invalidated. Local
  state is cleared regardless of network result.

## Guards & hydration

- `AuthGuard` consumes `AuthSessionCubit` (replaces the Phase 0 `DefaultSessionReader`
  `isAuthenticated=false` stub). Authenticated = stored access token present (D3).
- On launch: token present → guard unblocks immediately; `GET /users/me` hydrates `User` in the
  background. 401 during hydration runs the standard single-refresh-then-force-logout pipeline.
- Unauthenticated → `/login`; post-login default destination is the tenant dashboard
  (`activeRole`, default `tenant`).

## Test coverage (required)

- `UserRepositoryImpl.addRole` test asserts token write happens **before** the user emission.
- Password-change Cubit test asserts session clear + login navigation on success.
- `AuthSessionCubit` test: cold start with/without stored token; hydration 401 → logout.
- Widget test at 3 breakpoints × EN/AR: role-switch surface shows correct destinations by
  `roles[]`, not `activeRole` alone.
