# Contract: Adaptive App Shell

Branch `001-phase0-project-foundation` · Spec `spec.md` · Plan `plan.md` · Model `data-model.md`

## Purpose

Defines how the app adapts its navigation structure across window sizes (FR-013, SC-007) so every dashboard/screen later phases build renders inside a consistent, tested shell.

## Breakpoint model (decision D4)

| `AppBreakpoint` | Width (dp) | Shell structure |
|---|---|---|
| `compact` | `< 600` | `NavigationBar` (bottom nav) |
| `medium` | `600 – 839` | `NavigationRail` (side rail) |
| `expanded` | `≥ 840` | `NavigationRail` (extended, side rail) |

- Breakpoints come from `MediaQuery.sizeOf(context).width`.
- Breakpoints decide **structure only**; value scaling stays with `flutter_screenutil` (constitution §Toolchain).

## Implementation (decision D1 — approved)

`AppAdaptiveShell` is hand-rolled over Material's built-in `NavigationBar` / `NavigationRail` (~60 lines), **replacing** the constitution-locked `flutter_adaptive_scaffold` package because that package is discontinued upstream (deprecated + archived, flutter/flutter#162965). No new third-party dependency is added. **Approved by the user on 2026-08-05** (see `plan.md` → Constitution Check, D1).

## Contract rules

1. **Shell owns navigation chrome only** — destination list (`appDestinations`), selected index, content pane. It never renders business content; screens render in the content pane via the router.
2. **Destination set is role-aware** (Phase 1+): the shell reads `roles[]` from the user session (constitution §Roles) to show/hide landlord- vs tenant-destinations. Permission-sensitive UI reads `roles[]`, never `activeRole` alone. Phase 0 ships a static placeholder destination list.
3. **State preservation:** switching between breakpoints (resize/rotation) keeps the selected destination and does not recreate the content subtree (IndexedStack/similar).
4. **No overflow/jank** at any width (SC-007): rail labels collapse to icons on narrow-medium, extended rail on expanded.
5. **RTL-safe:** Material handles mirroring; the shell must not hardcode left/right (SC-003).
6. **Tested** at all three breakpoints × English/Arabic (validation scenarios).

## Consumed by

- `home` placeholder (Phase 0), every dashboard in Phases 1–6.

## Verification (validation scenarios)

- At 360dp → bottom `NavigationBar`; at 768dp and 1280dp → `NavigationRail` (extended at 1280dp).
- Resize between classes preserves selected destination and content state.
- Arabic renders mirrored without custom left/right logic.
