# Contract: Become a Landlord (in-flow)

Branch `003-shop-listing-management` · Spec `spec.md` (FR-001/FR-002/FR-013) · Research `research.md` (D7)

## Purpose

Defines what happens when a tenant-only account taps "List a shop". It MUST NOT re-implement the
Phase 1 `UserRepository.addRole(UserRole.landlord)` + token rotation — it reuses the injected Phase 1 seam
(D7). This contract only wires that seam into the listing flow and defines the UX.

## Trigger & gate

- Trigger: My Listings → "List a shop" (FR-001), OR the in-app onboarding "Become a Landlord"
  entry point.
- Gate: permission-sensitive code reads `roles[]`, never `activeRole` (FR-013). If
  `roles.contains(landlord)` → go straight to the create form. Otherwise → bottom sheet.

## Bottom sheet flow (FR-002)

1. User taps "List a shop"; `roles[]` lacks `landlord`.
2. A bottom sheet explains the landlord role (become a landlord / list your shop), with a single
   action button: "Become a Landlord". Dismissal = stay in My Listings (no listing created).
3. Confirm → call the shared seam (below). Show loading state on the button; single-tap guard.
4. Success → dismiss sheet, proceed into the create form (FR-001 continues).
5. Failure → show the typed `Failure` message inside the sheet, keep it open for retry.

## The shared seam (Phase 1, reused — never duplicated)

```dart
final userRepo = getIt<UserRepository>();
final user = await userRepo.addRole(UserRole.landlord);   // POST /users/me/roles — Phase 1 impl already
                                                          // writes the fresh token pair via onTokensUpdated
await userRepo.switchActiveRole(UserRole.landlord);       // persisted activeRole for dashboard reopen
```

**Order matters (constitution §Roles & sessions):** `addRole` returns a fresh token pair — the OLD
access token may not carry the new role's permissions. The new tokens are written to the session
BEFORE the caller proceeds; `switchActiveRole` picks which dashboard renders on reopen (persisted via
`shared_preferences`).

**Failure tolerance:** if `addRole` succeeds but `switchActiveRole` fails, the user still proceeds into
the create flow — permissions come from `roles[]`, not `activeRole` (FR-013, D7). The switch failure
is surfaced as a non-blocking notice, not a blocker.

**Error mapping:** `addRole` failures use the Phase 1 `Failure` set (`UserFailure`/roles variants) via
the existing `ErrorMapper`; no new listing `Failure` types are invented here.

## Ownership of tokens

This contract NEVER reads/writes tokens directly. Token replacement is exclusively
`SessionController.onTokensUpdated` (auth feature owns token lifecycle). The listing flow just reuses
the user feature's public seam.

## After the role is granted

- `roles[]` now includes `landlord` → all landlord-gated listing endpoints are authorized (the
  backend keys off roles, §8.2).
- The user's dashboard/`activeRole` stays tenant unless they switch (not this contract's job).
- The next "List a shop" tap bypasses the sheet entirely.

## Related files

- `lib/features/user/repository/user_repository.dart` — `addRole`, `switchActiveRole` (source of the seam)
- `lib/features/auth/presentation/session/session_controller.dart` — `onTokensUpdated`
- `lib/features/user/data/models/user_role.dart` — `UserRole.landlord`
