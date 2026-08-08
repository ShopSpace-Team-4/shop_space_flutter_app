# ShopSpace Phase 1 - Frontend API Guide

This document is meant for the frontend team. It summarizes the Phase 1 backend API, the available endpoints, the expected request/response shape, and the most important behavior to know while integrating.

## 1) Base URL

- Production: https://shopspace-backend-production.up.railway.app/api/v1
- Development: https://shopspace-backend-production.up.railway.app/api/v1 (the Flutter app uses this Railway base for dev/staging/prod)

Example:
- https://shopspace-backend-production.up.railway.app/api/v1/auth/login

Frontend environment variable:

```env
VITE_API_URL=https://shopspace-backend-production.up.railway.app/api/v1
```

Quick endpoint reference:
- `POST /auth/signup`
- `POST /auth/login`
- `POST /auth/verify`
- `GET /users/me`
- `PATCH /users/me/roles`

## 2) Response Format

All successful responses follow this pattern:

```json
{
  "message": "Success message",
  "status": 200,
  "data": {}
}
```

Important:
- `data` may be omitted for endpoints that only return a message.
- Errors are handled by the global error middleware and are returned as exception-based error responses.

## 3) Authentication

### Access token
Use the access token in the `Authorization` header:

```http
Authorization: Bearer <accessToken>
```

### Refresh token
Refresh tokens are returned from login and refresh-token endpoints. They are not sent in the header normally; they are sent in the request body for refresh.

## 4) Auth Endpoints

### 4.1 Signup

- Method: POST
- Path: /api/v1/auth/signup

Request body:

```json
{
  "firstName": "Ahmed",
  "lastName": "Khaled",
  "email": "ahmed@example.com",
  "phone": "+201000000000",
  "password": "StrongPass123!"
}
```

Notes:
- The user is created as unverified.
- An OTP is sent to the email.

Success response:

```json
{
  "message": "Signup successful. Please check your email for an OTP code.",
  "status": 201,
  "data": {
    "userId": "<user-id>"
  }
}
```

---

### 4.2 Login

- Method: POST
- Path: /api/v1/auth/login

Request body:

```json
{
  "email": "ahmed@example.com",
  "password": "StrongPass123!"
}
```

Success response:

```json
{
  "message": "Login successful",
  "status": 200,
  "data": {
    "accessToken": "<jwt>",
    "refreshToken": "<jwt>"
  }
}
```

Important:
- The user must already be verified before login succeeds.

---

### 4.3 Google Sign-In

- Method: POST
- Path: /api/v1/auth/google

Request body:

```json
{
  "idToken": "<google-id-token>"
}
```

Success response:

```json
{
  "message": "Google login successful",
  "status": 200,
  "data": {
    "accessToken": "<jwt>",
    "refreshToken": "<jwt>"
  }
}
```

Notes:
- This is for Google-based authentication.
- A new user can be created through this flow if no account exists.
- A Google account is not auto-linked to an existing password account in this flow.

---

### 4.4 Verify Account

- Method: POST
- Path: /api/v1/auth/verify

Request body:

```json
{
  "email": "ahmed@example.com",
  "otpCode": "123456"
}
```

Success response:

```json
{
  "message": "Account verified successfully",
  "status": 200,
  "data": null
}
```

---

### 4.5 Resend OTP

- Method: POST
- Path: /api/v1/auth/resend-otp

Request body:

```json
{
  "email": "ahmed@example.com"
}
```

Success response:

```json
{
  "message": "A new OTP code has been sent to your email",
  "status": 200,
  "data": null
}
```

---

### 4.6 Logout

- Method: POST
- Path: /api/v1/auth/logout

Headers:

```http
Authorization: Bearer <accessToken>
```

Success response:

```json
{
  "message": "Logged out successfully",
  "status": 200,
  "data": null
}
```

Notes:
- This invalidates the current session by bumping the token version.

---

### 4.7 Refresh Token

- Method: POST
- Path: /api/v1/auth/refresh-token

Request body:

```json
{
  "refreshToken": "<refresh-token>"
}
```

Success response:

```json
{
  "message": "Token refreshed successfully",
  "status": 200,
  "data": {
    "accessToken": "<jwt>",
    "refreshToken": "<jwt>"
  }
}
```

---

### 4.8 Forgot Password

- Method: POST
- Path: /api/v1/auth/forgot-password

Request body:

```json
{
  "email": "ahmed@example.com"
}
```

Success response:

```json
{
  "message": "If that email exists, a reset code has been sent",
  "status": 200,
  "data": null
}
```

---

### 4.9 Reset Password

- Method: POST
- Path: /api/v1/auth/reset-password

Request body:

```json
{
  "email": "ahmed@example.com",
  "otpCode": "123456",
  "newPassword": "NewStrongPass123!"
}
```

Success response:

```json
{
  "message": "Password reset successfully. Please log in again.",
  "status": 200,
  "data": null
}
```

## 5 User Endpoints

### 5.1 Get Current User Profile

- Method: GET
- Path: /api/v1/users/me

Headers:

```http
Authorization: Bearer <accessToken>
```

Success response:

```json
{
  "message": "success",
  "status": 200,
  "data": {
    "id": "<user-id>",
    "firstName": "Ahmed",
    "lastName": "Khaled",
    "email": "ahmed@example.com",
    "phone": "+201000000000",
    "roles": ["tenant"],
    "activeRole": "tenant",
    "avatarUrl": null,
    "isVerified": true,
    "createdAt": "2026-08-04T00:00:00.000Z"
  }
}
```

---

### 5.2 Update Profile

- Method: PUT
- Path: /api/v1/users/me

Headers:

```http
Authorization: Bearer <accessToken>
```

Request body:

```json
{
  "firstName": "Amr",
  "lastName": "Ali",
  "phone": "+201234567890"
}
```

Success response:

```json
{
  "message": "Profile updated successfully",
  "status": 200,
  "data": {
    "id": "<user-id>",
    "firstName": "Amr",
    "lastName": "Ali",
    "email": "ahmed@example.com",
    "phone": "+201234567890",
    "roles": ["tenant"],
    "activeRole": "tenant",
    "avatarUrl": null,
    "isVerified": true,
    "createdAt": "2026-08-04T00:00:00.000Z"
  }
}
```

---

### 5.3 Update Password

- Method: PUT
- Path: /api/v1/users/me/password

Headers:

```http
Authorization: Bearer <accessToken>
```

Request body:

```json
{
  "currentPassword": "StrongPass123!",
  "newPassword": "NewStrongPass123!"
}
```

Success response:

```json
{
  "message": "Password updated successfully",
  "status": 200,
  "data": null
}
```

---

### 5.4 Change Active Role

- Method: PATCH
- Path: /api/v1/users/me/active-role

Headers:

```http
Authorization: Bearer <accessToken>
```

Request body:

```json
{
  "role": "tenant"
}
```

Success response:

```json
{
  "message": "Active role updated successfully",
  "status": 200,
  "data": {
    "id": "<user-id>",
    "roles": ["tenant"],
    "activeRole": "tenant"
  }
}
```

Notes:
- This changes the UI-selected active role.
- It does not change the actual authorization roles unless the role is already assigned to the account.

---

### 5.5 Add a Role to the Account

- Method: POST
- Path: /api/v1/users/me/roles

Headers:

```http
Authorization: Bearer <accessToken>
```

Request body:

```json
{
  "role": "landlord"
}
```

Success response:

```json
{
  "message": "Role updated successfully",
  "status": 200,
  "data": {
    "profile": {
      "id": "<user-id>",
      "roles": ["tenant", "landlord"],
      "activeRole": "tenant"
    },
    "tokens": {
      "accessToken": "<jwt>",
      "refreshToken": "<jwt>"
    }
  }
}
```

Notes:
- This is how a tenant becomes a landlord on the account.
- A fresh token pair is returned because the user’s permissions changed.

---

### 5.6 Link Google Account

- Method: PATCH
- Path: /api/v1/users/me/link-google

Headers:

```http
Authorization: Bearer <accessToken>
```

Request body:

```json
{
  "idToken": "<google-id-token>"
}
```

Success response:

```json
{
  "message": "Google account linked successfully",
  "status": 200,
  "data": {
    "id": "<user-id>",
    "googleId": "<google-id>",
    "avatarUrl": "<avatar-url>"
  }
}
```

Notes:
- This is the only endpoint that links Google to an existing password account.
- It checks that the Google account is not already linked to another user.

---

### 5.7 Delete Account

- Method: DELETE
- Path: /api/v1/users/me

Headers:

```http
Authorization: Bearer <accessToken>
```

Success response:

```json
{
  "message": "Account deleted successfully",
  "status": 200,
  "data": null
}
```

## 6) Important Frontend Notes

### 6.1 Token handling
- Store the access token securely.
- Store the refresh token securely.
- On login or refresh, update both tokens in your app state.

### 6.2 Role behavior
- The backend now uses `roles: string[]` and `activeRole: string`.
- `activeRole` is mainly a UI selection and should not be treated as the only source of permission.
- Permission checks should be based on `roles`.

### 6.3 Verification status
- After signup, the user is not verified yet.
- Frontend should redirect the user to the OTP verification screen after signup.

### 6.4 Google auth flow
- The frontend must get the Google ID token from Google’s SDK first.
- Then send it to `/api/v1/auth/google` or `/api/v1/users/me/link-google` depending on the scenario.

### 6.5 Password change behavior
- Changing the password revokes other logged-in sessions by increasing token version.
- The frontend should force re-login after a password change if the app uses stored tokens aggressively.

## 7) Quick Integration Checklist

- Implement login and signup screens.
- Add OTP verification flow.
- Store access and refresh tokens.
- Add protected-route logic using the access token.
- Read `roles` from the profile response and use them for UI permission decisions.
- Use `activeRole` for the current dashboard toggle.
- Handle Google sign-in and Google link flow.

## 8) Recommended Frontend Flow for Phase 1

1. User signs up.
2. User verifies account using OTP.
3. User logs in.
4. Frontend requests `/api/v1/users/me` to get profile information.
5. Frontend stores `roles` and `activeRole`.
6. Frontend uses the roles array for permission-based UI logic.
7. If the user wants to add a new role, call `/api/v1/users/me/roles` and update tokens.
