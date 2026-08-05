# Contract: Design Tokens

Branch `001-phase0-project-foundation` · Spec `spec.md` · Plan `plan.md` · Model `data-model.md`

## Purpose

Defines how design tokens are sourced, structured, and consumed so every later phase renders from the same single source of truth (FR-002, SC-005).

## Source (single source of truth)

- Figma file: **`shop-space-ui`** via Composio Figma MCP (verified active connection).
- Extraction is **node/style-based** (decision D7): token values are read from fill/paint, type, and effect properties of style-owning nodes — not pixel-derived.

## Contract rules

1. **Extract once, centralize.** Tokens are pulled into `lib/core/theme/` (AppColors, AppTypography, AppSpacing, AppRadius, AppElevation) as compiled Dart constants. No re-extraction per screen, no runtime token loading.
2. **Never invent values.** Every token's value traces to a Figma node/style. If a required token is missing (e.g. no error-state frame), build it consistently from existing tokens **and flag the gap** (FR-002 acceptance).
3. **Light theme only.** No dark palette is constructed (SC-008).
4. **Screen-specific frames** are pulled at the *start* of that screen's work (constitution §Design source), layered on top of the existing tokens — tokens are never re-pulled wholesale per screen.
5. **No hardcoded values in widgets.** Widgets reference `Theme.of(context)` and the token classes; magic numbers are banned (SC-005).
6. **Scaling:** value tokens (spacing, radii) scale via `flutter_screenutil` (`.r`); typography via `.sp`; never via breakpoints. Breakpoints only decide structure (decision D4).

## Token surface (produced by Phase 0)

| Surface | Contents | Consumed by |
|---|---|---|
| `AppColors` | background/surface/text/accent/semantic/stroke groups | all features |
| `AppTypography` | display/headline/title/body/label scale → Material `TextTheme` | all features |
| `AppSpacing` | named spacing scale | layout throughout |
| `AppRadius` | named radii | shapes, cards, inputs |
| `AppElevation` | named shadows | cards, sheets, nav |

## Gap-handling protocol

- Missing Figma frame for a *state* (loading/error/empty): build with existing tokens, document the choice, flag in the phase notes.
- Missing token for a specific *value*: reuse nearest token, flag.

## Verification (validation scenarios)

- Sample UI (placeholder home) renders using only token-derived styles; a global grep finds no hardcoded colors/radii in feature widgets.
- Token values match Figma source for spot-checked tokens (background, primary, heading font size).

---

## Extraction record (T013, 2026-08-05)

Extracted via Composio Figma MCP from file `pvU6vSwQkWqwT27HVS4Jcp` (`shop space ui`), nodes:
- Website section `7:12781` → Design System `2:313` → `DSColors-Details` `2:304` (named token table), `DSTypography` `1:1117` (type scale), `DSComponents` `2:652` (radius/shadows).
- Mobile App section `104:262` (radii, shadows, spacing).

### Colors (named table in `DSColors-Details`, light mode)

| Group | Token | Hex |
|---|---|---|
| brand | `--brand-primary` | `#2563EB` |
| brand | `--brand-primary-hover` | `#1D4ED8` |
| brand | `--brand-primary-subtle` | `#EFF6FF` |
| brand | `--brand-primary-border` | `#BFDBFE` |
| brand | `--brand-accent` | `#14B8A6` |
| brand | `--brand-accent-hover` | `#0D9488` |
| brand | `--brand-accent-subtle` | `#F0FDFA` |
| status | `--status-success` | `#22C55E` |
| status | `--status-success-subtle` | `#F0FDF4` |
| status | `--status-success-text` | `#16A34A` |
| status | `--status-warning` | `#F59E0B` |
| status | `--status-warning-subtle` | `#FFFBEB` |
| status | `--status-warning-text` | `#D97706` |
| status | `--status-danger` | `#EF4444` |
| status | `--status-danger-subtle` | `#FEF2F2` |
| status | `--status-danger-text` | `#DC2626` |
| surface | `--bg-base` | `#F8FAFC` |
| surface | `--bg-elevated` | `#FFFFFF` |
| surface | `--bg-sunken` | `#F1F5F9` |
| surface | `--bg-overlay` | `#FFFFFF` |
| surface | `--bg-inverse` | `#0F172A` |
| text | `--text-primary` | `#0F172A` |
| text | `--text-secondary` | `#475569` |
| text | `--text-tertiary` | `#94A3B8` |
| text | `--text-disabled` | `#CBD5E1` |
| text | `--text-inverse` | `#FFFFFF` |
| text | `--text-link` | `#2563EB` |
| stroke | `--border-subtle` | `#F1F5F9` |
| stroke | `--border-base` | `#E2E8F0` |
| stroke | `--border-strong` | `#CBD5E1` |
| stroke | `--border-focus` | `#93C5FD` |
| stroke | `--border-brand` | `#2563EB` |

> Note: `--bg-base` is `#F8FAFC`, not the `#F5F5F5` referenced in older quickstart notes. The Figma table is the source of truth (FR-002).

### Typography (type scale, `DSTypography` 1:1117)

| Style | size | weight | lineHeight (px) | figmaToken |
|---|---|---|---|---|
| Display XL | 56 | 800 | 60.48 | `--text-7xl` |
| Display L | 44 | 800 | 48.4 | `--text-6xl` |
| Heading 1 | 36 | 700 | 41.4 | `--text-5xl` |
| Heading 2 | 30 | 700 | 36 | `--text-4xl` |
| Heading 3 | 24 | 600 | 31.2 | `--text-3xl` |
| Heading 4 | 20 | 600 | 27 | `--text-2xl` |
| Body L | 16 | 400 | 26.4 | `--text-lg` |
| Body M | 14 | 400 | 22.4 | `--text-base` |
| Body S | 13 | 400 | 20.15 | `--text-sm` |
| Caption | 11 | 500 | 15.4 | `--text-xs` |
| Mono | 13 | 400 | 20.8 | `--font-mono` (JetBrains Mono) |

Fonts: **Inter** (UI text, weights 300–800), **IBM Plex Sans Arabic** (Arabic, weights 300–700), **JetBrains Mono** (code/tokens, 400–600).

### Radii (`cornerRadius`)

Website DS: Btn `9999` (pill), Text Input `10`, Tag `6`, Avatar `12`, Image `16`, Container `18`, Checkbox `2`, Text `3`.
Mobile: Button `999`, Image `19`, Container `10`/`12`/`14`/`16`/`20`, indicator `1`.
→ mapped: small `6`, medium `10`, large `16`, pill `9999`, circular `9999` (mobile buttons `999` ≈ pill).

### Elevation (DROP_SHADOW effects)

| Level | offset | blur | color |
|---|---|---|---|
| low | (0,1) | 4 | `rgba(0,0,0,0.06)` |
| medium | (0,2) | 12 | `rgba(15,23,42,0.08)` |
| high | (0,4) | 16 | `rgba(37,99,235,0.40)` (brand-tinted, e.g. primary CTA) |
| button | (0,3) | 10 | `rgba(37,99,235,0.35)` |

### Spacing (frame paddings / gaps, mobile section)

Observed values: `4, 8, 10, 12, 14, 16, 24, 32, 40` (+ fractional 8.5). Named scale:
`xs: 4`, `sm: 8`, `md: 12`, `lg: 16`, `xl: 24`, `2xl: 32`, `3xl: 40`.

> Gap flagged (T059): Figma (`shop-space-ui`) has no loading/error/empty frames. The shared states shipped in Phase 0 were built **consistently from existing tokens** — never invented (constitution §4, gap-handling protocol above):
> - `AppLoadingView` — `CircularProgressIndicator` in `AppColors.primary`, label in `AppTypography.bodyLarge` + `AppColors.textSecondary`, spacing from `AppSpacing`.
> - `AppErrorView` — icon/color derived from the typed `Failure` variant (`AppColors.error`/`AppColors.warning`), localized message via the `error*` l10n keys, manual Retry `FilledButton`; unauthorized variant adds a sign-in surface using the existing `authLogin` key.
> - `AppEmptyView` — `Icons.inbox_outlined` in `AppColors.textTertiary`, title in `AppTypography.heading4`, supporting message in `AppTypography.bodyMedium` + `AppColors.textSecondary`, spacing from `AppSpacing`.
