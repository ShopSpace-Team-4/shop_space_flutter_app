# ShopSpace — Phase 1 Flutter Implementation Plan

**Scope of this document:** Flutter client only. UI/UX comes from Figma (design team owns visuals; accessed live via the Composio Figma MCP). Backend/API is owned by another team — the Auth & User API is now finalized and documented (see Section 3.1); other feature APIs are still pending and are marked as "expected" contracts to hand to the backend team. This plan defines *how the Flutter app will be built*: architecture, packages, data flow, responsive/adaptive strategy, and a phase-by-phase breakdown so each phase can be turned into an independent spec-kit spec and handed to an implementation LLM (via OpenCode).

**Sources:**
- ShopSpace Phase 1 PRD v1.1 (Shop Rental Marketplace + AI Business Advisor)
- `FRONTEND_PHASE1_API_GUIDE.md` (Auth & User API, finalized)
- Figma: `shop-space-ui` — https://www.figma.com/design/pvU6vSwQkWqwT27HVS4Jcp/shop-space-ui (accessed via Composio MCP by the implementing LLM)

---

## 1. Key Assumptions (confirmed with you)

| Decision | Choice |
|---|---|
| State management | BLoC / Cubit (`flutter_bloc`) |
| Starting point | Brand new Flutter project, empty repo |
| Backend API | REST, `/api/v1` prefix. Auth & User endpoints are finalized (Section 3.1). Listings/Search/Advisor endpoints are not final yet — this plan defines the shape the Flutter app needs, as a requirements list for the backend team |
| Landlord–tenant contact | No in-app chat. Tenant taps landlord's phone number on a listing → deep-links into WhatsApp (`url_launcher` + `wa.me` link). An "Inquiry" is a logged record, not a chat thread |
| AI Advisor responses | Simple request → full response (no token streaming) |
| Localization | Arabic/English + RTL is a day-one architectural requirement |
| Role model | Every account defaults to **tenant**. A user becomes a landlord later — either by tapping "List a shop" (Phase 2) or "Become a Landlord" in Profile (Phase 4) — which calls `POST /users/me/roles`. Accounts can hold **both** roles simultaneously; `activeRole` just controls which dashboard is currently shown |
| Platforms & layout | iOS + Android, **adaptive and responsive** across phones and tablets — real adaptive layouts (e.g. list-detail side-by-side on wide screens), not just scaled text |
| Design source | Figma file accessed live via the Composio Figma MCP. Design tokens (colors, typography, spacing, radii, elevation) are pulled **once, in Phase 0**, and converted into the app's theme. Screen-specific frames are then pulled **per phase**, at the start of that phase's spec, by the implementing LLM |

---

## 2. Architecture Overview

**Pattern:** Two-layer, feature-first architecture — **no separate domain layer**. Each feature has `data/` (datasources + models) and `repository/` (interface + implementation); the `repository/` interface is what BLoCs/Cubits in `presentation/` talk to directly. There are no entities or use-case classes — the repository interface *is* the contract, and its methods are the "use cases." This keeps the codebase leaner while still separating "how data is fetched" (data/) from "the contract the UI depends on" (repository/) from "UI + state" (presentation/).

```
lib/
  core/
    di/                   → get_it service locator + injectable setup
    network/               → dio client, interceptors (auth header, 401/refresh, error mapping, envelope unwrap)
    router/                → go_router config + route guards (auth state, roles/activeRole)
    theme/                  → design tokens pulled from Figma (colors, type scale, spacing, radii), ThemeData
    responsive/              → screen_util init + breakpoint definitions + adaptive layout helpers (see 2.3)
    localization/             → easy_localization setup, ARB/JSON files, RTL helpers
    storage/                   → flutter_secure_storage wrapper (tokens), shared_preferences wrapper
    errors/                     → Failure classes, exception → failure mapping (maps API {message,status} envelope)
    widgets/                     → shared/reusable UI components (built to be breakpoint-aware)
    utils/                        → validators, formatters, constants
  features/
    auth/                          → signup, login, OTP verify/resend, forgot/reset password, google sign-in, logout, refresh
      data/          → datasources (auth_remote_data_source.dart) + models (user_model.dart, auth_tokens_model.dart)
      repository/    → auth_repository.dart (interface), auth_repository_impl.dart
      presentation/  → screens/, widgets/, cubit/
    user/                           → profile, password update, role add/switch, google link, delete account
      data/ repository/ presentation/
    listings/
      data/ repository/ presentation/
    search/
      data/ repository/ presentation/
    advisor/                        → AI Business Advisor chat
      data/ repository/ presentation/
    inquiries/                       → "contacted landlord via WhatsApp" log/status
      data/ repository/ presentation/
  main.dart
  app.dart
  bootstrap.dart                    → env-specific entrypoints (dev/staging/prod)
```

**Note:** `auth/` and `user/` are split — `auth` owns the unauthenticated flows (signup/login/OTP/password reset) and token lifecycle; `user` owns everything behind a valid session (profile, roles, password change, account deletion). Both are built in Phase 1, since the API guide covers both together, but `user`'s role-switch **UI** (the visible toggle) is surfaced in Phase 4 (Profile) and the "List a shop" CTA in Phase 2 — both call the same `UserRepository` methods (see 2.1a).

### 2.1a Repository pattern (replaces domain/use-cases)

- `repository/*.dart` (interface) is an abstract class listing methods like `Future<User> login(String email, String password)`, `Future<User> addRole(String role)` — this is what Cubits depend on (injected via `get_it`), not the concrete `*_impl.dart`.
- `*_repository_impl.dart` implements the interface, calling the datasource, mapping raw/DTO models from `data/models/` into the models used by the UI (in this simplified architecture, the same `freezed` models are reused across data → repository → presentation, rather than mapping into separate domain entities).
- Cross-feature reuse (e.g. Phase 2's "List a shop" and Phase 4's "Become a Landlord" both needing to add a role) is done by both presentation layers depending on the same injected `UserRepository`, not by a shared use-case class.

### 2.1 Core package choices

| Concern | Package | Why |
|---|---|---|
| State management | `flutter_bloc`, `equatable` | Agreed choice; predictable, testable |
| Routing | `go_router` | Declarative, supports auth/role guards, deep linking |
| Networking | `dio` | Interceptors for auth headers, token refresh, envelope unwrapping, error mapping |
| DI | `get_it` + `injectable` | Standard, low-boilerplate, works well with clean architecture |
| Models/serialization | `freezed` + `json_serializable` | Immutable models, less boilerplate |
| Local persistence | `flutter_secure_storage` (tokens), `shared_preferences` (non-sensitive prefs, e.g. last-picked locale/activeRole) |
| Localization/RTL | `easy_localization` or Flutter's `intl` + `flutter_localizations`; direction handled automatically by `MaterialApp` per locale |
| Images | `image_picker` (listing photos), `cached_network_image` (display) |
| External links | `url_launcher` (WhatsApp deep link, phone/mail fallback) |
| Google Sign-In | `google_sign_in` (obtains the ID token the backend expects at `/auth/google` and `/users/me/link-google`) |
| Adaptive/responsive | `flutter_screenutil` for proportional scaling (font sizes, paddings, widget dimensions against a Figma reference design size) **combined with** Material 3 window size classes via `MediaQuery`/`LayoutBuilder` for actual layout/structure switching; `flutter_adaptive_scaffold` for the nav-rail ↔ bottom-nav / list-detail scaffold pattern (see 2.3) |
| Forms/validation | Manual `Form`/`TextFormField` + custom validators (email, phone `+2XXXXXXXXXX`, password strength) |
| Environment config | `--dart-define` + a `lib/core/env/` config class (dev/staging/prod base URLs) |
| Testing | `bloc_test`, `mocktail`, `flutter_test`, `integration_test` |

### 2.2 Networking layer — matches the real API envelope

Every response follows `{ message, status, data }`; errors come from a global error middleware. The `dio` layer must:
- Unwrap `data` generically (a `Result<T>`/`ApiResponse<T>` wrapper parsed once, reused everywhere) rather than each repository re-parsing the envelope.
- Map non-2xx responses (and the `message`/`status` they carry) into typed `Failure`s (e.g. `ValidationFailure`, `UnauthorizedFailure`, `NotVerifiedFailure`, `ServerFailure`).
- Auto-attach `Authorization: Bearer <accessToken>` to every request except the unauthenticated auth endpoints.
- On a `401`, attempt a **single** silent refresh via `POST /auth/refresh-token` using the stored refresh token, retry the original request once, and if that also fails, clear stored tokens and force the user back to the login screen (this also covers the "password change revokes other sessions" case from the API guide).

### 2.3 Adaptive & responsive strategy

Target range: **phones + tablets**, portrait and landscape, with genuinely different layouts at wider widths (not just stretched phone UI). Two tools handle two different jobs — they are not redundant:

- **`flutter_screenutil`** handles *proportional scaling* — font sizes, paddings, margins, icon/widget dimensions (`.sp`, `.w`, `.h`, `.r`) — scaled against the Figma reference frame size (e.g. design at 375×812 for phone, or a second reference size for tablet if Figma provides separate tablet frames). Initialized once in `bootstrap.dart` via `ScreenUtilInit`, wrapping the app. Every screen built from Figma measurements uses `screen_util` extensions instead of hardcoded pixel values, so spacing/typography stays visually consistent with the design at any screen size within a breakpoint.
- **Material 3 breakpoints** (via `core/responsive/`) handle *layout/structure* changes — how many panes are shown, bottom nav vs nav rail, whether filters are a sidebar or a bottom sheet. `screen_util` does not decide this; it only scales values within whatever layout is chosen.
- Breakpoints: **compact** (<600dp — phone), **medium** (600–839dp — small tablet / phone landscape), **expanded** (≥840dp — large tablet).
- `core/responsive/` exposes a `Breakpoint` enum + a `ResponsiveLayout`/`AdaptiveScaffold` wrapper so every screen picks its layout declaratively instead of ad-hoc `MediaQuery` checks scattered around.
- App shell (built in Phase 0): bottom navigation bar on compact, navigation rail on medium/expanded (`flutter_adaptive_scaffold` gives this out of the box).
- List-detail screens (Search results + listing detail in Phase 3, My Listings + edit in Phase 2, Advisor sessions + chat in Phase 5) use a **two-pane layout on expanded**, single-pane push-navigation on compact — called out explicitly in each of those phases below.
- This is a first-class requirement in every phase's Definition of Done, not a Phase 6 add-on — but a final cross-breakpoint QA sweep (including verifying `screen_util` scaling looks right, not just the pane-switching) still happens in Phase 6.

---

## 3. API Integration

### 3.1 Auth & User API — FINALIZED (drives Phase 1)

Base URL: `http://localhost:3000` (dev), prefix `/api/v1`. All responses: `{ message, status, data }`.

**Auth (`/auth`)**
| Endpoint | Method | Purpose |
|---|---|---|
| `/auth/signup` | POST | Create unverified user, OTP emailed. Body: `firstName, lastName, email, phone, password` |
| `/auth/login` | POST | Body: `email, password` → `{accessToken, refreshToken}`. Fails if unverified |
| `/auth/google` | POST | Body: `idToken` → `{accessToken, refreshToken}`. Creates a new account if none exists; does **not** auto-link to an existing password account |
| `/auth/verify` | POST | Body: `email, otpCode` |
| `/auth/resend-otp` | POST | Body: `email` |
| `/auth/logout` | POST | Auth required; bumps token version, invalidating the session |
| `/auth/refresh-token` | POST | Body: `refreshToken` → new `{accessToken, refreshToken}` |
| `/auth/forgot-password` | POST | Body: `email` |
| `/auth/reset-password` | POST | Body: `email, otpCode, newPassword` |

**User (`/users`)** — all require `Authorization: Bearer <accessToken>`
| Endpoint | Method | Purpose |
|---|---|---|
| `/users/me` | GET | Profile incl. `roles[]`, `activeRole`, `isVerified` |
| `/users/me` | PUT | Update `firstName, lastName, phone` |
| `/users/me/password` | PUT | `currentPassword, newPassword` — revokes other sessions |
| `/users/me/active-role` | PATCH | `role` — switches which dashboard is shown; does **not** grant new permissions |
| `/users/me/roles` | POST | `role` — adds a role to the account (e.g. tenant → tenant+landlord); returns a **fresh token pair**, which must overwrite stored tokens |
| `/users/me/link-google` | PATCH | `idToken` — links Google to the current password account |
| `/users/me` | DELETE | Deletes the account |

**Client-side rules derived from the guide (Phase 1 Definition of Done includes these):**
- Permission-sensitive UI reads from `roles[]`, never from `activeRole` alone.
- `activeRole` drives which dashboard/shell is rendered; persisted locally so app reopens on the last-used dashboard.
- After `POST /users/me/roles` succeeds, the new tokens **must** replace the stored pair immediately (old access token may not reflect the new role's permissions).
- After a successful password update, proactively clear local session and route to login (rather than waiting for a 401), since the guide states other sessions are revoked.
- Signup → always routes to OTP verification, never straight to login.

### 3.2 Other feature APIs — expected/pending (Phases 2, 3, 5)

Unchanged from the original plan — Listings, Search, Inquiries and Advisor endpoints are not finalized yet. Each of those phases' specs still includes an "Expected API Contract" section as a requirements draft for the backend team, using the same `{message, status, data}` envelope and Bearer-auth convention established in 3.1 for consistency.

---

## 4. Phase Breakdown (for spec-kit)

Each phase is scoped to be an independent spec: goal, screens (Figma frame names to be pulled live via the Composio MCP), BLoCs/Cubits, data models, API contract, adaptive-layout behavior, and Definition of Done.

### Phase 0 — Project Foundation, Design Tokens & Adaptive Shell
**Goal:** A running, empty-but-wired app, themed from real Figma tokens, with the adaptive navigation shell in place.

**Includes:**
- Flutter project scaffold, folder structure above.
- **Figma MCP pull (one-time):** connect to the `shop-space-ui` file via the Composio MCP and extract colors, type scale, spacing scale, corner radii, and elevation/shadow tokens → translate into `core/theme/` (`ThemeData`, `ColorScheme`, `TextTheme`).
- `core/responsive/` breakpoint helpers (compact/medium/expanded) + `ScreenUtilInit` setup (design reference size taken from the Figma frames) + adaptive app shell (`flutter_adaptive_scaffold`: bottom nav on compact, nav rail on medium/expanded).
- `go_router` setup with placeholder routes and auth/role-based redirect guards.
- `dio` client + interceptors per Section 2.2 (envelope unwrap, auth header, single-retry refresh-on-401, Failure mapping).
- DI container (`get_it`/`injectable`) wiring skeleton.
- Localization scaffolding: EN + AR files, locale switching, RTL verified on a sample screen at all three breakpoints.
- Secure token storage wrapper.
- Global error/loading/empty-state widgets (breakpoint-aware).
- Environment config (dev/staging/prod via `--dart-define`, matching `http://localhost:3000/api/v1` for dev).
- Lint rules, basic CI (`flutter analyze` / `flutter test`).

**Depends on:** Nothing (first phase).
**Blocks:** Every other phase.

---

### Phase 1 — Authentication, Verification & Account/Role Management
**Goal:** Full auth lifecycle against the finalized API: signup, OTP verify, login, Google sign-in, forgot/reset password, logout, token refresh — plus the shared role-management logic (`add role`, `switch active role`) that Phases 2 and 4 will trigger from their own screens.

**Screens (Figma frames to pull for this phase):** Splash, Login, Sign Up, OTP Verification, Resend OTP state, Forgot Password, Reset Password, Google sign-in button/state. *(No dedicated "role selection" screen — role defaults to tenant.)*

**BLoCs:** `AuthCubit` (global session state: unauthenticated/authenticating/authenticated + current `roles`/`activeRole`), `SignUpCubit`, `OtpCubit`, `PasswordResetCubit`, `GoogleAuthCubit`.

**Shared repository methods built here (consumed directly by later phases' Cubits via DI):** `UserRepository.addRole(role)` (→ `POST /users/me/roles`, overwrites stored tokens), `UserRepository.switchActiveRole(role)` (→ `PATCH /users/me/active-role`). These live on the `user/repository/user_repository.dart` interface — Phase 2 and Phase 4 Cubits both inject `UserRepository` and call the same two methods, no separate use-case classes needed.

**Data models:** `User { id, firstName, lastName, email, phone, roles[], activeRole, avatarUrl, isVerified, createdAt }`, `AuthTokens { accessToken, refreshToken }` — defined once in `data/models/`, reused unchanged by `repository/` and `presentation/`.

**API endpoints:** All of Section 3.1's `/auth/*` endpoints, plus `GET /users/me` (to hydrate session on app start) and the two `UserRepository` methods above.

**Adaptive behavior:** Auth screens are single-column and centered on all breakpoints (a max content width on tablet, not a two-pane layout — there's nothing to split).

**Definition of Done:** New user can sign up → verify via OTP (with resend) → log in → land on tenant home. Google sign-in works as a login/signup path. Forgot/reset password flow works end-to-end. Session persists across restarts via secure-stored tokens; a 401 triggers exactly one silent refresh attempt before forcing re-login. Logout and account deletion both clear local session correctly. RTL verified. `AddRoleUseCase`/`SwitchActiveRoleUseCase` are unit-tested even though no UI calls them yet in this phase.

**Depends on:** Phase 0.

---

### Phase 2 — Shop Listing Management (Landlord side)
**Goal:** Landlord can create, edit, publish, and manage their listings. Tenant-only users are upgraded to landlord on first use via the shared `AddRoleUseCase` from Phase 1.

**Screens:** My Listings, Create/Edit Listing (multi-step: details → photos → price/lease terms → review), Listing status (draft/published/rented), Mark as Rented action, "Become a Landlord" confirmation sheet (shown the first time a tenant taps "List a shop").

**BLoCs:** `MyListingsCubit`, `ListingFormCubit` (multi-step form state + photo upload progress). On "List a shop" tap: if `roles` doesn't already contain `landlord`, call the injected `UserRepository.addRole('landlord')` first, then proceed into the create-listing flow; `activeRole` is switched via `UserRepository.switchActiveRole('landlord')` at the same time.

**Data models:** `ShopListing { id, landlordId, title, description, photos[], sizeSqm, price, leaseDurationMonths, amenities[], location, shopType, status(draft/published/rented) }`.

**Expected API endpoints (pending backend):**
- `POST /listings`, `PUT /listings/{id}`, `DELETE /listings/{id}`
- `POST /listings/{id}/photos` (multipart upload)
- `GET /listings/mine`
- `PATCH /listings/{id}/status`

**Adaptive behavior:** My Listings uses a **two-pane list-detail layout on expanded** (list on the left, selected listing preview/edit on the right); single-pane push-navigation on compact/medium. The multi-step create/edit form is a single centered column at every breakpoint (wizard-style flows don't benefit from splitting).

**Definition of Done:** Landlord can complete create→publish, edit an existing listing, upload/reorder/remove photos, mark as rented. A brand-new tenant-only account successfully becomes dual-role via the flow above, and their stored tokens are refreshed accordingly. RTL, `screen_util` scaling, and all three breakpoints verified.

**Depends on:** Phase 0, Phase 1 (needs `AuthCubit` and the `UserRepository` interface + implementation).

---

### Phase 3 — Shop Search & Discovery (Tenant side)
**Goal:** Tenant can search/filter listings, view details, and contact the landlord via WhatsApp.

**Screens:** Search/Browse (list + filters: location, price range, size, shop type), Listing Detail, "Contact via WhatsApp" action, Inquiry confirmation, My Inquiries (contact history).

**BLoCs:** `SearchCubit` (query + filter state, pagination), `ListingDetailCubit`, `ContactLandlordCubit` (fires the inquiry-log call + launches WhatsApp).

**Data models:** `SearchFilters { location, priceMin, priceMax, sizeMin, sizeMax, shopType }`, reuses `ShopListing`, `Inquiry { id, tenantId, listingId, landlordId, contactedAt, channel }`.

**Expected API endpoints (pending backend):**
- `GET /listings?location=&priceMin=&priceMax=&size=&type=&page=`
- `GET /listings/{id}`
- `POST /inquiries`
- `GET /inquiries/mine`

**WhatsApp deep link logic:** `url_launcher` opens `https://wa.me/<landlordPhone>?text=<prefilled message>`; falls back to native dialer/SMS if WhatsApp isn't installed. Fires `POST /inquiries` in parallel.

**Adaptive behavior:** Search screen is a **two-pane list-detail layout on expanded** (results list left, selected listing detail right, filters as a persistent sidebar); on compact/medium, filters live in a bottom sheet/drawer and tapping a result pushes a full-screen detail page.

**Definition of Done:** Search meets the PRD's <2s target (skeleton loaders, debounced filters), listing detail renders fully, WhatsApp contact opens with a prefilled message and logs the inquiry, My Inquiries reflects "Contacted" status. RTL and Arabic number/price formatting verified at all breakpoints.

**Depends on:** Phase 0, Phase 1. Independent of Phase 2 (buildable against seeded/mock listing data).

---

### Phase 4 — Profile, Role Switching & Account Settings
**Goal:** User can view/edit their profile, change password, link Google, switch between tenant/landlord dashboards (if dual-role), become a landlord from settings, and delete their account.

**Screens:** My Profile (view/edit name, phone, avatar), Change Password, Linked Accounts (Google link), Role Switcher (only visible if `roles.length > 1`), "Become a Landlord" entry point (alternate trigger to the one in Phase 2), Delete Account confirmation.

**BLoCs:** `ProfileCubit`, `PasswordUpdateCubit`, `RoleSwitchCubit` (calls the same injected `UserRepository.switchActiveRole` used in Phase 2), `AccountDeletionCubit`.

**Data models:** Reuses `User` from Phase 1.

**API endpoints (finalized, Section 3.1):** `PUT /users/me`, `PUT /users/me/password`, `PATCH /users/me/active-role`, `POST /users/me/roles`, `PATCH /users/me/link-google`, `DELETE /users/me`.

**Adaptive behavior:** Settings-style list on compact (each row pushes a sub-screen); on medium/expanded, a **master-detail layout** (settings list left, selected setting's form right) matching the pattern used in Phases 2 and 3.

**Definition of Done:** Profile view/edit works; password change succeeds and correctly forces local logout (per 3.1's session-revocation rule); Google linking works; role switcher toggles `activeRole` and the app shell updates to the corresponding dashboard immediately; a tenant can become a landlord from here too, reusing the exact same `UserRepository.addRole` call as Phase 2's "List a shop" trigger (no duplicated logic); account deletion works and clears session. RTL and `screen_util` scaling verified at all breakpoints.

**Depends on:** Phase 0, Phase 1 (`UserRepository`, `AuthCubit`).

---

### Phase 5 — AI Business Advisor (Chat UI)
**Goal:** Tenant can chat with the RAG-based advisor and get non-streamed, grounded answers.

**Screens:** Advisor entry point (tenant home + search empty state), Chat screen (message list + input), Session list (past conversations), source/citation disclosure UI, "informational only" disclaimer banner.

**BLoCs:** `AdvisorSessionsCubit`, `AdvisorChatCubit` (send → loading → full response).

**Data models:** `ChatSession { id, userId, createdAt, title }`, `ChatMessage { id, sessionId, role(user/assistant), content, sources[], createdAt }`.

**Expected API endpoints (pending backend):**
- `POST /advisor/sessions`
- `GET /advisor/sessions/mine`
- `POST /advisor/sessions/{id}/messages`
- `GET /advisor/sessions/{id}/messages`

**Adaptive behavior:** **Two-pane layout on expanded** — session list left, active chat right (classic messaging-app pattern); single-pane on compact/medium (session list → tap → full-screen chat).

**Definition of Done:** New session → question → loading state → full response with sources + disclaimer visible. Old sessions listable/reopenable. 3–5s response wait handled gracefully with a timeout/error state, not an infinite spinner. RTL and all breakpoints verified.

**Depends on:** Phase 0, Phase 1. Independent of Phases 2–4.

---

### Phase 6 — Localization Hardening, Non-Functional Polish & Release Prep
**Goal:** Take the app from "feature-complete" to launch-ready.

**Includes:**
- Full Arabic translation pass (all strings externalized from Phase 0 onward get real AR copy).
- RTL visual QA across every screen (mirrored icons, alignment, number/currency formatting).
- **Cross-breakpoint QA sweep**: every screen re-checked at compact/medium/expanded, portrait and landscape, on real tablet hardware or simulators — not just phone-scaled.
- Performance pass: image caching/lazy loading, list pagination tuning, cold-start time.
- Error/empty/offline states audited across all features; token-refresh-failure path re-verified end-to-end.
- Accessibility pass (font scaling, contrast, tap target sizes at all breakpoints).
- App icons, splash screen, store listing assets.
- Build flavors finalized (dev/staging/prod), release signing, CI pipeline for build/test.
- Test coverage pass on core Cubits (`bloc_test`) and critical flows (`integration_test`: signup → verify → login → become landlord → create listing → search → contact via WhatsApp → advisor chat → switch role → logout).

**Definition of Done:** App passes an RTL/Arabic QA checklist and a breakpoint QA checklist, has no untranslated strings, meets the PRD's performance/availability NFRs client-side, and is buildable as a signed release artifact for both platforms.

**Depends on:** Phases 0–5 substantially complete.

---

## 5. Suggested Spec-Kit Sequencing

1. **Phase 0** (must be first)
2. **Phase 1** (Auth & Roles — fully spec-ready now, API is finalized)
3. **Phase 2** and **Phase 3** can run in parallel once Phase 1 lands — agree on the `ShopListing` model shape once (e.g. as a short shared-contracts note) before splitting the two sessions
4. **Phase 4** — depends only on Phase 1's use cases; can be built in parallel with 2/3
5. **Phase 5** — fully independent of 2/3/4, can run in parallel
6. **Phase 6** last

## 6. Open Items to Resolve Before/During Phase 0

- Confirm the Composio Figma MCP connection is authenticated and the implementing LLM (OpenCode) can reach the `shop-space-ui` file before Phase 0 starts, since token extraction is the first real task.
- Confirm phone-number format/validation rule for the WhatsApp deep link and for the `phone` field validation in Phase 1 (the API guide's example uses `+201000000000` — confirm this `+2` country-code format is enforced client-side too).
- Confirm whether "mark as rented" auto-hides a listing from search or just changes its badge/status (affects Phase 2 & 3 contract).
- Backend team should review Section 3.2's "Expected API Contract" per phase early — this is effectively the API requirements doc from the client's point of view, following the same envelope/auth conventions already finalized in Section 3.1.
- Confirm minimum supported tablet size (e.g. 7" vs 10"+) so the `expanded` breakpoint's two-pane layouts are tested against real target hardware.
