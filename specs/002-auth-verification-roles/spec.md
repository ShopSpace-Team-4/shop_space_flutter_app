# Feature Specification: Phase 1 — Authentication, Verification & Account/Role Management

**Feature Branch**: `002-auth-verification-roles`

**Created**: 2026-08-06

**Status**: Finalized

**Input**: User description: "create a spec for Phase 1 — Authentication, Verification & Account/Role Management in ShopSpace_Flutter_Implementation_Plan.md and if you have any clarification ask me"

## Clarifications

### Session 2026-08-06

- **Q1 — Phone number validation (FR-002)**: Enforce the Egyptian `+2` international format client-side (e.g. `+201000000000`), matching the API guide's example. (Option A)
- **Q2 — Password strength (FR-003)**: Minimum 8 characters with at least one letter and one number. (Option A)
- **Q3 — Google sign-in account collision (FR-006)**: When the Google email already belongs to a password-based account, show a clear, localized message that the account exists and guide the user to sign in with their password; linking Google from Profile is noted as a later-phase option. (Option A)
- **Q4 — OTP retry limit (FR-004)**: Enforce a client-side cap of 5 failed OTP attempts; after the limit, disable input and prompt the user to request a new code. (Option A)
- **Q5 — Accessibility & Figma fidelity (FR-014/FR-015)**: Add a measurable accessibility requirement to this phase's testing — screen-reader labels on inputs and error messages, touch targets of at least 44dp, and verified contrast. All auth-screen UI, colors, and widgets must come from the `shop-space-ui` Figma file, and screens must be responsive at all breakpoints with no placeholder widgets. (Option A)

## User Scenarios & Testing *(mandatory)*

### User Story 1 - New user signs up and verifies their email with an OTP code (Priority: P1)

A brand-new user opens the app and taps "Sign Up". They enter their first name, last name, email, phone number, and a password. The app checks the inputs and, when valid, creates their account and immediately sends them to an OTP verification screen (never straight to login). The verification code arrives by email; the user types it in and verifies. They are then taken to the login screen where they can sign in for the first time and land on the tenant home.

**Why this priority**: Sign-up is the entry point to the entire product. Every user journey that follows (browsing, listing, advisor) requires a verified, signed-in account, so this slice is the first real value a new customer experiences.

**Independent Test**: On a fresh install, complete sign-up with valid data and confirm the app routes to OTP verification, the account is created, and verification succeeds. This delivers a verified account ready to log in — a complete, standalone slice.

**Acceptance Scenarios**:

1. **Given** a new user with valid first name, last name, email, phone, and password, **When** they submit the sign-up form, **Then** the account is created and the app immediately routes to the OTP verification screen.
2. **Given** the user submits an empty, malformed, or otherwise invalid field, **When** the form is validated, **Then** a clear, localized message identifies the invalid field and no account is created.
3. **Given** the user enters the correct OTP code, **When** they submit it, **Then** verification succeeds and the app routes to the login screen so the user can sign in.
4. **Given** the user enters an incorrect or expired OTP code, **When** they submit it, **Then** they see a friendly error and remain on the verification screen to try again.
5. **Given** an account already exists for the submitted email, **When** sign-up is submitted, **Then** the user is informed and guided to sign in instead of being blocked silently.

---

### User Story 2 - Returning user signs in and stays signed in across app restarts (Priority: P1)

A returning user opens the app. If they were signed in on this device before, the app recognizes them and takes them straight to the tenant home without re-entering credentials. If their session has expired, the app silently renews it in the background; if that renewal fails, it returns them to the login screen. When signing in fresh, the user enters email and password; wrong credentials produce a clear message, and a not-yet-verified account is told to complete verification.

**Why this priority**: This is the "session" promise of the product — a signed-in user must not be forced to log in repeatedly. It is the core retention mechanic and the foundation every authenticated feature builds on.

**Independent Test**: Sign in once, force-close and relaunch the app, and confirm the user lands directly on the tenant home. Then simulate an expired session and confirm exactly one silent renewal attempt happens, with a clean return to login if it fails. Delivers a persistent, secure session as a standalone slice.

**Acceptance Scenarios**:

1. **Given** a user signed in previously on this device, **When** they open the app, **Then** they are taken to the tenant home without being asked to log in again.
2. **Given** the user enters the wrong password, **When** they attempt to sign in, **Then** they see a friendly, localized error and remain on the login screen.
3. **Given** the user's session has expired, **When** they use the app, **Then** the app silently renews the session once and retries; if renewal fails, the session is cleared and the user is returned to the login screen — no crash and no raw technical error.
4. **Given** the user's account exists but has not been verified, **When** they attempt to sign in, **Then** they are informed the account needs verification and are routed to the verification flow.

---

### User Story 3 - User can recover a forgotten password (Priority: P2)

A user who forgot their password taps "Forgot Password", enters their email, and receives an OTP code. They enter the code along with a new password and reset it. They can then sign in with the new password.

**Why this priority**: Password recovery is essential account hygiene and prevents users from being permanently locked out of the product. It is secondary only because existing signed-in users are unaffected.

**Independent Test**: Request a reset for an existing account, complete the code + new password steps, and sign in with the new password. This is a complete, independently testable slice.

**Acceptance Scenarios**:

1. **Given** a user with an existing account taps "Forgot Password" and enters their email, **When** they submit, **Then** a verification code is issued and the user is guided through entering it.
2. **Given** the user enters the correct code and a valid new password, **When** they submit, **Then** the password is changed and the user can sign in with the new password.
3. **Given** the user enters an incorrect or expired code, **When** they submit, **Then** they see a friendly error and remain in the reset flow.
4. **Given** the new password does not meet the required strength rules, **When** it is validated, **Then** a clear message explains the rule and the reset is not applied.

---

### User Story 4 - User can sign in or create an account with Google (Priority: P2)

A user taps "Continue with Google" on the login (or sign-up) screen. They authorize the app in the system Google dialog. If no account exists for their Google email, one is created automatically and they are signed in; if an account exists, they are signed in to it. If the Google email already belongs to a password-based account, the app shows a clear message that the account exists and guides the user to sign in with their password instead. If the user cancels the Google dialog, they return to the login screen with no side effects.

**Why this priority**: Google sign-in removes the sign-up friction and is a primary acquisition path alongside email sign-up. It is P2 because email sign-up is the guaranteed baseline, but it must exist for launch parity.

**Independent Test**: On a fresh install, sign in with Google and confirm a new account is created and the user lands on the tenant home; then sign out and sign back in with Google to confirm the existing account is recognized. A complete, standalone slice.

**Acceptance Scenarios**:

1. **Given** a user with no existing ShopSpace account taps "Continue with Google", **When** they authorize access, **Then** a new account is created for their Google email and they are signed in.
2. **Given** a user whose Google email already matches an existing account, **When** they authorize access, **Then** they are signed in to that account.
3. **Given** the user cancels or denies the Google authorization dialog, **When** the flow ends, **Then** they return to the login screen with no account created and no error shown.
4. **Given** a user whose Google email belongs to an existing password-based account, **When** they authorize access, **Then** the user is shown a clear, localized message that an account with this email already exists and is guided to sign in with their password.

---

### User Story 5 - The shared account/role-management capability is built and unit-tested (Priority: P2)

Behind the scenes, this phase builds the single shared capability to (a) add a role to the current account (e.g. turn a tenant into a tenant + landlord) and (b) switch which role is currently active. No screen triggers these yet — "List a shop" (Phase 2) and Profile (Phase 4) will call the exact same capability — so they are verified now through automated tests. When a role is added, the app must adopt the fresh credentials returned by the change so the new role's access works immediately.

**Why this priority**: This shared logic is the seam later phases depend on. Building and testing it now (while the API is finalized) de-risks Phases 2 and 4 and guarantees the "add landlord once, use everywhere" behavior stays consistent.

**Independent Test**: Run the automated test suite for this phase and confirm add-role and switch-active-role transitions — including the fresh-credential replacement — pass with no UI present. Delivers the tested capability as a standalone slice.

**Acceptance Scenarios**:

1. **Given** the current account is tenant-only, **When** the add-role capability is invoked for the landlord role, **Then** the account gains the landlord role and the app immediately adopts the fresh credentials returned by the change.
2. **Given** an account holds more than one role, **When** the switch-active-role capability is invoked, **Then** the active role changes and the choice is remembered so the app reopens on the corresponding dashboard.
3. **Given** the add-role or switch-active-role change fails, **When** it completes, **Then** the account's roles and active role remain unchanged and a friendly error is surfaced.

---

### User Story 6 - User can sign out (Priority: P3)

A signed-in user signs out from the app. Their local session is fully cleared, the backend is informed, and the app returns to the login screen. Reopening the app keeps them signed out.

**Why this priority**: Sign-out is important for device sharing and privacy but is not on the critical acquisition path; it is the smallest slice in this phase.

**Independent Test**: Sign in, sign out, confirm the app returns to login, relaunch, and confirm the session does not reappear. A complete, standalone slice.

**Acceptance Scenarios**:

1. **Given** a signed-in user taps Sign Out, **When** the action completes, **Then** the local session is fully cleared and the app shows the login screen.
2. **Given** a signed-out user, **When** they reopen the app, **Then** they are asked to sign in and are not taken to any authenticated screen.
3. **Given** the sign-out request fails due to connectivity, **When** the user retries, **Then** the local session is still cleared so the device is not left logged in.

---

### Edge Cases

- User attempts to sign in with an account that exists but has not completed OTP verification — directed to verification, not silently blocked.
- User signs up with an email that is already registered — informed and guided to sign in.
- OTP code is incorrect, expired, or re-sent during its cooldown period — friendly feedback and a countdown-guarded resend.
- OTP code is entered incorrectly 5 times — input is disabled and the user is prompted to request a new code; a fresh code resets the attempt counter.
- User's session expires mid-use — exactly one silent renewal, retry the interrupted action once, then a clean return to login.
- App is opened with a stored session but no connectivity — the app must not wrongly log the user out; it shows a retry-able state (or makes use of the stored session where safe) rather than forcing re-login on a transient network fault.
- User cancels or denies the Google authorization dialog — graceful return to login, no account side effects.
- Google sign-in where the email already belongs to a password-based account — a clear, localized message explains the existing password account and guides the user to sign in with their password.
- Network fails mid sign-up, verification, or reset — a clear error with a retry path; no half-completed state that leaves the user confused.
- Auth screens viewed in Arabic — full RTL mirroring; text fields, links, and messages lay out correctly.
- Auth screens used with a screen reader or large system font — fields, links, and error messages remain reachable and usable.
- Device rotates or is resized across a breakpoint during an auth flow — the screen stays usable, single-column and centered.
- The backend and app disagree on a validation rule — the backend's rejection surfaces as a friendly message, never a raw technical error.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The system MUST let a new user create an account by providing first name, last name, email, phone, and password. On successful creation, the user MUST be routed to OTP verification — never straight to login.
- **FR-002**: The system MUST validate the phone number on sign-up, enforcing the Egyptian `+2` international format (e.g. `+201000000000`).
- **FR-003**: The system MUST enforce a password strength rule at sign-up and password reset — a minimum of 8 characters with at least one letter and one number — with a clear explanation when the rule is not met.
- **FR-004**: The system MUST verify a new account with an emailed OTP code, MUST support requesting a new code (with a sensible cooldown and countdown so the user knows when they can resend), and MUST keep the user on the verification screen with friendly feedback until verification succeeds. The system MUST cap failed OTP attempts at 5 per code; after the limit is reached, the input MUST be disabled and the user prompted to request a new code.
- **FR-005**: The system MUST let a user sign in with email and password, MUST show a friendly, localized error for wrong credentials, and MUST route a not-yet-verified account into the verification flow.
- **FR-006**: The system MUST let a user sign in with Google using the Google account on their device, creating a new account automatically when none exists for that email, and returning gracefully to the login screen if the user cancels. When the Google email already belongs to a password-based account, the user MUST be shown a clear, localized message that an account with this email already exists and be guided to sign in with their password.
- **FR-007**: The system MUST let a user recover a forgotten password by requesting a code for their email, entering the code with a new password, and then signing in with the new password. Incorrect/expired codes MUST produce friendly feedback within the reset flow.
- **FR-008**: The system MUST let a signed-in user sign out, which MUST inform the backend and fully clear the local session so the app returns to login and stays there on relaunch.
- **FR-009**: On a single session expiry, the system MUST silently renew the session once and retry the interrupted action; if renewal fails, it MUST clear the session and return the user to login — no crash and no raw technical error.
- **FR-010**: The system MUST remember a signed-in user on the device (secure storage) and, on app launch, recognize them and route to the tenant home without re-entering credentials. A stored session MUST NOT be discarded purely because of a transient network fault.
- **FR-011**: The system MUST provide a single shared capability to add a role to the current account. When a role is added, the fresh credentials returned by the change MUST replace the stored ones immediately so the new role's access works right away. This capability MUST be covered by automated tests in this phase even though no screen calls it yet.
- **FR-012**: The system MUST provide a single shared capability to switch the active role, and MUST remember the last-used role locally so the app reopens on the corresponding dashboard. Automated tests MUST cover the switch in this phase.
- **FR-013**: The shared session-clearing path built for sign-out MUST be the single mechanism used to clear a local session, so later phases (password change, account deletion) reuse it without duplicating logic.
- **FR-014**: Every screen in this phase MUST be single-column and centered on all three screen-size classes, with content width capped on wider screens (there is no two-pane layout for auth). All UI, colors, and widgets MUST come from the `shop-space-ui` Figma file, and screens MUST be responsive at every breakpoint with no layout overflow and no placeholder widgets.
- **FR-015**: English and Arabic MUST both be supported; every auth message MUST be localized, RTL layouts MUST render correctly, and the app MUST respond to language switching without breaking the current flow.
- **FR-016**: Every auth action (sign-up, verification, sign-in, Google sign-in, reset, sign-out) MUST either succeed or end in a friendly, localized message with a clear retry path — raw technical errors MUST never reach the user.
- **FR-017**: Every auth screen MUST meet measurable accessibility criteria — screen-reader labels on inputs and error messages, touch targets of at least 44dp, and verified color contrast — checked as part of this phase's testing.

### Key Entities *(include if feature involves data)*

- **User**: The account record — first name, last name, email, phone, roles, active role, verification status, avatar, creation time. Created at sign-up; the profile (roles/active role/status) drives which areas of the app the user may access.
- **Session credentials**: The signed-in user's credential pair, held in secure device storage, enabling automatic sign-in on launch, credential attachment on requests, and silent renewal on expiry.
- **Verification code (OTP)**: A time-limited code emailed to the user to verify a new account or confirm a password reset; validity and expiry are controlled by the backend.
- **Account role**: A permission label on the account (e.g. tenant, landlord). Every account starts as tenant; roles are added through one shared capability. A separate "active role" choice only decides which dashboard is shown, not what the user may do.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A brand-new user can go from first app open to signed in and on the tenant home in under 3 minutes using email sign-up + OTP verification.
- **SC-002**: A previously signed-in user is taken to the tenant home on app launch without entering credentials; the session-expiry path completes within 5 seconds (one silent renewal + retry, then a clean return to login on failure).
- **SC-003**: The forgot/reset password flow completes end to end for a valid request, and a reset user can sign in with the new password.
- **SC-004**: Google sign-in works as both a sign-in and a new-account path, and a cancelled flow returns to login with no side effects.
- **SC-005**: 100% of auth actions either succeed or end in a friendly, localized message with a retry path — no crashes, no raw technical errors.
- **SC-006**: Sign-out fully clears the session; relaunching the app after sign-out always lands on login.
- **SC-007**: The add-role and switch-active-role capabilities pass automated tests (including fresh-credential replacement) with no UI triggering them yet.
- **SC-008**: All screens in this phase are verified at all three screen-size classes and in both English and Arabic (RTL), single-column and centered, with no layout overflow.
- **SC-009**: Every auth screen passes the accessibility checks — screen-reader labels on inputs and error messages, touch targets of at least 44dp, and verified color contrast.

## Assumptions

- iOS and Android are the only supported platforms; web/desktop is out of scope.
- English and Arabic are the only required locales; additional locales later are a supported extension, not a rebuild.
- After successful OTP verification the user is routed to the login screen to sign in (per the implementation plan's sign-up → verify → log in sequence); auto-login immediately after verification is not included.
- The verification code is delivered by email and its validity period is controlled by the backend; the app's role is to capture the code, resend on request (with a 60-second default cooldown and countdown), and surface clear feedback.
- A successful sign-in always persists the session on the device; there is no "remember me" option in this phase.
- Password change (`PUT /users/me/password`) and account deletion are Phase 4 scope; this phase builds the reusable session-clearing path those flows will use.
- The minimum supported tablet size for the expanded layout class is 10"+ (established in Phase 0).
- The backend enforces the same validation rules the app enforces; where they disagree, the backend's rejection surfaces as a friendly, localized message.
- Design for the auth screens comes from the `shop-space-ui` Figma file (pulled at the start of this phase via the Composio Figma MCP connection); screens not represented in the file use styles consistent with the existing design tokens and the gap is flagged.
- Session hydration on app launch relies on a valid stored session; a transient network fault must not be treated as a logged-out state.
