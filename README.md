# ShopSpace

**Shop Space Listings & AI Business Advisor** — A cross-platform Flutter application that connects shop tenants with available retail spaces, enhanced by an AI-powered business advisor.

## Screenshots

|                                                                                                       |                                                                                                       |                                                                                                       |
| ----------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| ![Screenshot 1](assets/screenshots/WhatsApp%20Image%202026-08-24%20at%208.29.36%20PM.jpeg)            | ![Screenshot 2](assets/screenshots/WhatsApp%20Image%202026-08-24%20at%208.29.36%20PM%20%281%29.jpeg)  | ![Screenshot 3](assets/screenshots/WhatsApp%20Image%202026-08-24%20at%208.29.36%20PM%20%282%29.jpeg)  |
| ![Screenshot 4](assets/screenshots/WhatsApp%20Image%202026-08-24%20at%208.29.36%20PM%20%283%29.jpeg)  | ![Screenshot 5](assets/screenshots/WhatsApp%20Image%202026-08-24%20at%208.29.35%20PM.jpeg)            | ![Screenshot 6](assets/screenshots/WhatsApp%20Image%202026-08-24%20at%208.29.34%20PM.jpeg)            |
| ![Screenshot 7](assets/screenshots/WhatsApp%20Image%202026-08-24%20at%208.29.34%20PM%20%281%29.jpeg)  | ![Screenshot 8](assets/screenshots/WhatsApp%20Image%202026-08-24%20at%208.29.34%20PM%20%282%29.jpeg)  | ![Screenshot 9](assets/screenshots/WhatsApp%20Image%202026-08-24%20at%208.29.34%20PM%20%283%29.jpeg)  |
| ![Screenshot 10](assets/screenshots/WhatsApp%20Image%202026-08-24%20at%208.29.34%20PM%20%284%29.jpeg) | ![Screenshot 11](assets/screenshots/WhatsApp%20Image%202026-08-24%20at%208.29.33%20PM.jpeg)           | ![Screenshot 12](assets/screenshots/WhatsApp%20Image%202026-08-24%20at%208.29.33%20PM%20%281%29.jpeg) |
| ![Screenshot 13](assets/screenshots/WhatsApp%20Image%202026-08-24%20at%208.29.33%20PM%20%282%29.jpeg) | ![Screenshot 14](assets/screenshots/WhatsApp%20Image%202026-08-24%20at%208.29.33%20PM%20%283%29.jpeg) | ![Screenshot 15](assets/screenshots/WhatsApp%20Image%202026-08-24%20at%208.29.33%20PM%20%284%29.jpeg) |
| ![Screenshot 16](assets/screenshots/WhatsApp%20Image%202026-08-24%20at%208.29.33%20PM%20%285%29.jpeg) | ![Screenshot 17](assets/screenshots/WhatsApp%20Image%202026-08-24%20at%208.29.33%20PM%20%286%29.jpeg) | ![Screenshot 18](assets/screenshots/WhatsApp%20Image%202026-08-24%20at%208.29.33%20PM%20%287%29.jpeg) |
| ![Screenshot 19](assets/screenshots/WhatsApp%20Image%202026-08-24%20at%208.29.33%20PM%20%288%29.jpeg) | ![Screenshot 20](assets/screenshots/WhatsApp%20Image%202026-08-24%20at%208.29.33%20PM%20%289%29.jpeg) | ![Screenshot 21](assets/screenshots/WhatsApp%20Image%202026-08-24%20at%208.29.32%20PM.jpeg)           |
| ![Screenshot 22](assets/screenshots/WhatsApp%20Image%202026-08-24%20at%208.29.32%20PM%20%281%29.jpeg) | ![Screenshot 23](assets/screenshots/WhatsApp%20Image%202026-08-24%20at%208.29.32%20PM%20%282%29.jpeg) |                                                                                                       |

## Features

- **Onboarding** — first-launch walkthrough
- **Authentication** — email/password sign-up & login, OTP verification, forgot/reset password, Google Sign-In
- **Home Feed** — curated shop listings with hero gradient banner and AI Advisor promo card
- **Search & Filter** — keyword search with real-time filtering across listings
- **Shop Detail** — full listing view with images, pricing, availability status, and WhatsApp contact link
- **Saved Listings** — bookmarked shops for quick access
- **Profile & Settings** — user account management, password change, language toggle
- **List a Shop** — landlord listing creation/editing flow with image picker
- **My Listings** — landlord dashboard for managing active listings
- **AI Space Advisor** — conversational AI chat for business/startup guidance
- **Adaptive Navigation** — bottom bar on mobile, navigation rail on tablet/desktop
- **Responsive UI** — all screens scale to any device size (Figma 375x812 reference frame)
- **Full RTL Support** — English & Arabic with right-to-left layout

## Tech Stack

| Layer            | Packages                                                        |
| ---------------- | --------------------------------------------------------------- |
| **State**        | `flutter_bloc` (Cubit-first)                                    |
| **Routing**      | `go_router` with `StatefulShellRoute`                           |
| **Networking**   | `dio` with interceptors, pretty logging                         |
| **DI**           | `get_it` + `injectable` (code generation)                       |
| **Models**       | `freezed` + `json_serializable` (immutable, union types)        |
| **Storage**      | `flutter_secure_storage` (tokens), `shared_preferences` (prefs) |
| **Responsive**   | `flutter_screenutil` + Material 3 window size classes           |
| **Images**       | `image_picker` + `cached_network_image`                         |
| **Auth**         | `google_sign_in` (ID token)                                     |
| **Localization** | `flutter_localizations` + `intl` (ARB files)                    |
| **Links**        | `url_launcher`                                                  |
| **Splash**       | `flutter_native_splash`                                         |
| **Env**          | `flutter_dotenv`                                                |

## Architecture

Feature-first, layered architecture:

```
lib/
├── main.dart                          # Entry point
├── bootstrap.dart                     # DI, env, router wiring
├── core/                              # Cross-cutting concerns
│   ├── di/                            #   Dependency injection (get_it + injectable)
│   ├── env/                           #   Environment config (flutter_dotenv)
│   ├── errors/                        #   Typed Failure classes
│   ├── localization/                  #   ARB files, LocalizationCubit
│   ├── network/                       #   Dio setup, interceptors, envelope unwrap
│   ├── responsive/                    #   Window size classes, AppAdaptiveShell
│   ├── router/                        #   GoRouter config, route guards
│   ├── storage/                       #   Secure & shared-prefs wrappers
│   ├── theme/                         #   Colors, typography, spacing, elevation, radius
│   ├── utils/                         #   Shared helpers
│   ├── validation/                    #   Form validators
│   └── widgets/                       #   Reusable UI (loading, error, empty views)
└── features/                          # Feature modules
    ├── advisor/                       #   AI Space Advisor chat
    ├── auth/                          #   Login, signup, OTP, password reset
    ├── home/                          #   Home feed screen
    ├── listing/                       #   List a shop, my listings, listing detail
    ├── onboarding/                    #   First-launch walkthrough
    ├── saved/                         #   Saved/bookmarked listings
    ├── search/                        #   Search & shop detail
    └── user/                          #   Profile, settings, password change
```

Each feature follows:

```
feature/
├── data/            # Datasources (dio) + freezed models
├── repository/      # Abstract interface + implementation
└── presentation/    # Screens, widgets, Cubits
```

Cubits depend only on repository interfaces (injected via `get_it`), never on datasources or `dio` directly.

## System Design

### Boot Sequence

```
main()
  │
  ├─ 1. WidgetsFlutterBinding.ensureInitialized()
  │     Set portrait-only orientation.
  │
  ├─ 2. dotenv.load('.env', isOptional: true)
  │     Loads env config (API_BASE_URL, GOOGLE_SERVER_CLIENT_ID, etc.)
  │     as a Flutter asset. Missing .env falls back to AppEnv.dev defaults.
  │
  ├─ 3. configureDependencies()
  │     get_it + injectable registers all singletons and factories.
  │
  ├─ 4. googleAuth.initialize()
  │     Google Sign-In plugin init (must complete before router builds).
  │
  ├─ 5. sessionCubit.initialize()
  │     Reads stored tokens from FlutterSecureStorage, hydrates
  │     roles/activeRole in background. Unblocks UI immediately.
  │
  ├─ 6. onboardingCubit.initialize()
  │     Resolves first-launch flag from shared_preferences so the
  │     global redirect never fires during bootstrap.
  │
  └─ 7. runApp(ShopSpaceApp)
        ScreenUtilInit wraps everything. MaterialApp.router receives
        the GoRouter, localization providers, and session cubit.
```

### Network Pipeline

All HTTP traffic flows through a fixed Dio interceptor chain:

```
Request
  │
  ├─ AuthInterceptor      Attaches `Authorization: Bearer <token>` header.
  │                        Skips unauthenticated endpoints (login, signup,
  │                        OTP, password reset, token refresh).
  │
  ├─ EnvelopeInterceptor   Unwraps `{ message, status, data }` on success.
  │                        Features receive `data` directly — never the
  │                        envelope wrapper.
  │
  ├─ SessionInterceptor    Handles 401 responses:
  │                        - Single-flight token refresh (concurrent 401s
  │                          share ONE refresh future).
  │                        - Original request retried exactly once
  │                          (gated by `extra['retried']`).
  │                        - Failed refresh → clear storage → emit
  │                          sessionExpired signal → router redirects
  │                          to /login.
  │
  ├─ ErrorInterceptor      Maps all non-2xx DioExceptions through
  │                        ErrorMapper → typed Failure subclass.
  │
  └─ PrettyDioLogger       Debug logging (enabled in dev/staging only).
```

### Token Lifecycle & Session Management

```
Storage: FlutterSecureStorage
  Keys: auth.accessToken, auth.refreshToken

┌─────────────────────────────────────────────────────┐
│  SessionController                                  │
│  - onTokensUpdated(tokens)  → persists new pair     │
│  - onSessionExpired()       → clears storage        │
│                               + emits broadcast     │
│                               stream signal         │
└─────────────────────────────────────────────────────┘
         ▲                                      ▲
         │                                      │
  TokenRefresher                          Router Guard
  - reads current pair from storage       - subscribes to sessionExpired
  - calls AuthDataSource.refreshToken     - redirects to /login on signal
  - returns new pair or null              - guards protected routes
    (null = force logout)
```

### Dependency Injection

```dart
// get_it is the service locator; injectable generates registrations.
final GetIt getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();
```

- **Singletons**: `Dio`, `TokenStorage`, `SessionController`, `AppRouter`, `AuthSessionCubit`, `LocalizationCubit`
- **Factories**: Repositories (per-feature), datasources (per-feature)
- Cubits are registered as factories (one per screen/flow), injected via `BlocProvider`
- Cross-feature reuse (e.g. `addRole`) = same repository injected into both Cubits

### Error Handling

All errors propagate as typed `Failure` subclasses — raw exceptions never reach the UI:

```
DioException
  │
  └─ ErrorInterceptor
       │
       └─ ErrorMapper.map(dioException) → Failure
            │
            ├─ NetworkFailure      (connection issues)
            ├─ TimeoutFailure      (5s connect/receive/send)
            ├─ OfflineFailure      (no internet)
            ├─ ServerFailure       (5xx)
            ├─ UnauthorizedFailure (401, non-refreshable)
            ├─ ValidationFailure   (422)
            ├─ RateLimited         (429)
            ├─ InvalidCredentials  (login failed)
            ├─ EmailNotVerified    (needs OTP)
            ├─ EmailAlreadyRegistered
            ├─ PhoneAlreadyRegistered
            ├─ InvalidOtp / OtpAttemptsExceeded
            ├─ GoogleSignInCancelled / GoogleSignInFailed
            ├─ ListingCreateFailed / ListingUpdateFailed / ...
            ├─ MediaUploadFailed / MediaReorderFailed / ...
            ├─ SaveListingFailed / UnsaveListingFailed
            └─ GenericFailure      (catch-all 4xx)
```

Each `Failure` carries a `messageKey` — a localization key resolved by the UI to display user-facing error text.

### Routing & Guards

`GoRouter` with `StatefulShellRoute` for adaptive navigation:

```
Auth Guard (authGuard)
  │ Reads: session.isAuthenticated, session.isBootstrapping
  │ Redirects unauthenticated users → /login
  │ Skipped during bootstrap (no flash)
  │
Role Guard (roleGuard)
  │ Reads: session.roles (full set, NOT activeRole)
  │ Redirects users without requiredRole → fallbackPath
  │ Used for: /list-a-shop, /my-listings (landlord-only)
  │
Session Expired Signal
  │ SessionController.sessionExpired stream
  │ Router subscribes, redirects to /login on emission
```

Route structure:

```
/onboarding          First-launch walkthrough (guarded by OnboardingCubit)
/login               Email/password sign-in
/signup              Registration
/otp-verification    OTP code entry
/forgot-password     Password reset request
/reset-password      New password entry
/                    Home feed (StatefulShellRoute.index)
  ├─ /search         Search & filter
  │   └─ /shop/:id   Shop detail
  ├─ /saved          Saved listings
  └─ /profile        User profile & settings
/list-a-shop         Landlord listing creation (role-guarded)
/my-listings         Landlord dashboard (role-guarded)
/advisor             AI Space Advisor chat
```

### Responsive System

Two independent systems with distinct responsibilities:

| System                         | Job                                     | Values                                            |
| ------------------------------ | --------------------------------------- | ------------------------------------------------- |
| `flutter_screenutil`           | Scales individual values (.sp/.w/.h/.r) | Against Figma reference frame 375×812             |
| Material 3 window size classes | Picks layout structure                  | Compact <600dp, Medium 600–839dp, Expanded ≥840dp |

```
AppAdaptiveShell
  ├─ Compact  (<600dp)  → Bottom navigation bar
  └─ Medium/Expanded    → Navigation rail (side)
```

Every UI component must:

- Scale all sizes, spacing, radius, icons, fonts with `.sp`/`.w`/`.h`/`.r`
- Use flex widgets (`Expanded`, `Flexible`, `Row`, `Column`, `Wrap`) for layout
- Never use raw pixel literals in `build`

### Localization

```
bootstrap()
  └─ LocalizationCubit
       ├─ Reads persisted locale from shared_preferences
       ├─ Falls back to system locale (Egypt → Arabic)
       └─ Emits Locale('en') | Locale('ar')

MaterialApp.router
  ├─ locale: provided by LocalizationCubit
  ├─ supportedLocales: [en, ar]
  └─ localizationsDelegates: [
       AppLocalizations.delegate,
       GlobalMaterialLocalizations.delegate,
       GlobalWidgetsLocalizations.delegate,
       GlobalCupertinoLocalizations.delegate,
     ]

ARB files: core/localization/app_en.arb, app_ar.arb
```

RTL is fully supported — `GlobalMaterialLocalizations` handles bidirectional text layout automatically.

### Storage Strategy

| Data                 | Store                  | Rationale                  |
| -------------------- | ---------------------- | -------------------------- |
| Access token         | `FlutterSecureStorage` | Encrypted, hardware-backed |
| Refresh token        | `FlutterSecureStorage` | Encrypted, hardware-backed |
| `activeRole`         | `shared_preferences`   | Non-sensitive, UI-only     |
| Locale preference    | `shared_preferences`   | Non-sensitive, UI-only     |
| Onboarding completed | `shared_preferences`   | Non-sensitive, UI-only     |

### Feature Layer Contract

```
┌─────────────────────────────────────────────────────┐
│  presentation/                                      │
│  Screens, widgets, Cubits                           │
│  Cubit depends on → Repository interface only       │
└───────────────────────┬─────────────────────────────┘
                        │ depends on interface
┌───────────────────────▼─────────────────────────────┐
│  repository/                                        │
│  Abstract interface + one Impl                      │
│  Impl depends on → Datasource                       │
└───────────────────────┬─────────────────────────────┘
                        │ depends on
┌───────────────────────▼─────────────────────────────┐
│  data/                                              │
│  Datasource (talks to Dio) + freezed models         │
│  Models flow unchanged into repository & present.   │
└─────────────────────────────────────────────────────┘

No domain layer. No entities. No use-case classes.
A repository method IS the use case.
```

## Getting Started

### Prerequisites

- Flutter SDK `^3.9.2` (installed at `C:\flutter`)
- Dart SDK (bundled with Flutter)
- Android Studio / Xcode for platform tooling
- A running instance of the [ShopSpace backend](https://shopspace-backend-production.up.railway.app)

### Installation

```bash
# Clone the repository
git clone <repo-url>
cd shop_space_flutter_app

# Install dependencies
flutter pub get

# Run code generation (freezed, injectable, json_serializable)
dart run build_runner build -d

# Copy environment config
cp .env.example .env
# Edit .env as needed

# Run the app
flutter run
```

### Environment Variables

All keys are read from `.env` at runtime via `flutter_dotenv`. Editing `.env` requires a full re-run (not hot reload).

| Variable                  | Description                                        | Default                                               |
| ------------------------- | -------------------------------------------------- | ----------------------------------------------------- |
| `APP_ENV`                 | Environment selector: `dev`, `staging`, `prod`     | `dev`                                                 |
| `API_BASE_URL`            | Backend base URL override                          | `https://shopspace-backend-production.up.railway.app` |
| `GOOGLE_SERVER_CLIENT_ID` | Google Sign-In web client ID (required on Android) | —                                                     |
| `GOOGLE_IOS_CLIENT_ID`    | iOS OAuth client ID (optional)                     | —                                                     |

### Quality Gate

```bash
dart run tool/quality.dart
```

Runs `flutter analyze` — must pass with zero issues before any commit.

## API

REST backend at `/api/v1`. Responses use envelope format `{ message, status, data }`, unwrapped once in the Dio layer. Non-2xx responses are mapped to typed `Failure` classes.

| Endpoint                | Method         | Description                  |
| ----------------------- | -------------- | ---------------------------- |
| `/auth/signup`          | POST           | Register with email/password |
| `/auth/login`           | POST           | Email/password login         |
| `/auth/google`          | POST           | Google Sign-In (ID token)    |
| `/auth/verify-otp`      | POST           | Verify OTP code              |
| `/auth/forgot-password` | POST           | Request password reset       |
| `/auth/reset-password`  | POST           | Reset with token             |
| `/users/me`             | GET            | Current user profile         |
| `/users/me/roles`       | POST           | Add a role (`landlord`)      |
| `/users/me/password`    | PUT            | Change password              |
| `/users/me`             | DELETE         | Delete account               |
| `/listings`             | GET/POST       | List/create shop listings    |
| `/listings/:id`         | GET/PUT/DELETE | Listing CRUD                 |
| `/listings/:id/save`    | POST           | Save/unsave listing          |
| `/advisor/chat`         | POST           | Send message to AI advisor   |
| `/search`               | GET            | Search listings              |

## Roles

- **Tenant** (default) — browse, search, save listings, contact landlord via WhatsApp
- **Landlord** — all tenant permissions + create/edit/manage listings
- Accounts can hold both roles. `activeRole` (persisted in `shared_preferences`) selects which dashboard renders.

## Localization

English (`app_en.arb`) and Arabic (`app_ar.arb`) with full RTL support. No hardcoded user-facing strings.

## Project Structure

- **8 feature modules**: `advisor`, `auth`, `home`, `listing`, `onboarding`, `saved`, `search`, `user`
- **12 core modules**: `di`, `env`, `errors`, `localization`, `network`, `responsive`, `router`, `storage`, `theme`, `utils`, `validation`, `widgets`
- **16 screens** across all features
- **23 screenshots** in `assets/screenshots/`

## License

Proprietary — All rights reserved.
