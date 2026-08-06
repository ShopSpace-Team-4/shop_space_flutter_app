# Contract: OTP Validation Semantics

Branch `002-auth-verification-roles` · Research D2/D4 · Plan `plan.md`

## Purpose

Defines the OTP screen's exact behavior — input handling, cooldown, and the 5-attempt cap (spec
clarification Q4) — so the widget and Cubit each own the correct slice of state.

## Input model (widget)

- One real `TextFormField`: `keyboardType: TextInputType.number`, `maxLength: 6`, digits-only
  (`FilteringTextInputFormatter.digitsOnly`), full-width under the six visual boxes.
- Six **display-only** boxes render the entered characters; the real field is transparent/overlaid.
- Accessibility: the real field has a single semantic label (e.g. "6-digit verification code"); the
  six boxes are wrapped in `ExcludeSemantics` so a screen reader reads one code, not six digits.
- Paste works via the single field; autofill hints enabled where the platform supports them.

## State machine (Cubit owns truth)

```
Initial
  → verify(otp)
      ├─ valid  → verified → navigate to next step (login / dashboard)
      ├─ invalid → attemptsRemaining -= 1
      │            ├─ attemptsRemaining > 0 → failure(InvalidOtp), field cleared
      │            └─ attemptsRemaining == 0 → isLocked = true (field disabled + "request new code")
      └─ transport error → failure(Network/…), no attempt deducted
  → resend()
      ├─ cooldown active (now < resendCooldownUntil) → ignored (button disabled)
      └─ cooldown expired → POST /auth/resend-otp
           ├─ success → attemptsRemaining = 5, resendCooldownUntil = now + 60s, isLocked = false
           └─ failure → keep state, show failure
```

## Timers

- Cubit holds the absolute `DateTime? resendCooldownUntil` (set to `now + 60s` on code emission and
  after each resend). Never stores a relative count.
- The widget owns a single `Timer.periodic(1s)` that recomputes "seconds remaining" for the button
  label and is **canceled in `dispose()`**. No timer survives navigation or rebuild.
- Tests assert on `resendCooldownUntil` (no fake async timers required for the countdown logic).

## Attempt cap (Q4)

- `attemptsRemaining` starts at 5; only an **invalid-code** response decrements it.
- At 0 → `isLocked`: input disabled, countdown keeps running, button text becomes "Request new
  code" (not "Resend").
- Successful resend resets attempts to 5 and re-enables the field.
- The cap lives in the Cubit, so navigating away and back cannot reset it without a resend.

## Verification outcomes

| Response | Consequence |
|---|---|
| 2xx verify | verified state → route to login (signup flow) or dashboard |
| `InvalidOtp` | decrement attempt; clear field; localized error |
| `OtpAttemptsExceeded` | lock immediately regardless of client counter |
| transport failure | no attempt decremented; retry allowed |

## Test coverage (required)

- `bloc_test`: success, invalid (remaining>0), invalid (remaining==0 → locked), resend success
  (resets cap + restarts cooldown), resend during cooldown (ignored), transport failure (no
  decrement).
- Widget test: 6 boxes fill from a single field; paste enters 6 digits; screen reader sees one
  label; disabled state at lock.
