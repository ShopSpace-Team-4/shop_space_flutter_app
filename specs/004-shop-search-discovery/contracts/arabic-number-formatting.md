# Contract: Arabic Number & Price Formatting (Phase 3)

Feature `004-shop-search-discovery` · Spec `spec.md` · Plan `plan.md` · Decision D9

## Purpose

Defines the single locale-aware number/price formatting surface used by every Phase 3
screen (search cards, detail, saved list). Resolves the Phase 2 gap-log items
#6/#7 (Latin-only compact `K`, no Arabic-Indic numeral support) and satisfies the spec edge
case: "amounts, sizes, dates, and filters render with correct Arabic digit and currency
formatting and full RTL mirroring".

## Surface — `core/utils/formatters.dart`

Cross-cutting (existing `core/utils/` folder, no new convention):

| Helper | Renders | AR (ar*) | EN |
|---|---|---|---|
| `formatPrice(double, AppLocalizations, {bool compact})` | `annualRentWithVat` + `currency` ("EGP") | Arabic-Indic digits, e.g. `٦٩٠٬٠٠٠ ج.م` | `EGP 690,000` |
| `formatPriceCompact(double, …)` | compact card price | Arabic-Indic + localized suffix, e.g. `٦٩٠ ألف` | `690K` |
| `formatArea(double, …)` | `areaSqm` | Arabic-Indic digits + localized "م²" | `120 m²` |
| `formatDate(DateTime, …)` | `availableFrom` | Arabic-Indic digits, localized date | localized date |
| `formatDeposit(int?, …)` / `formatLease(String?, …)` | deposit months / lease term | localized | localized |

Rules:
- Arabic-Indic digit conversion via `intl` `NumberFormat` with the active locale (already
  locked in Phase 0) — never a hand-rolled digit map.
- `annualRentWithVat` is display-only (FR-003, §8.4): the formatters read it, nothing ever
  submits or stores it.
- `currency` renders localized ("EGP" / "ج.م") per the existing token/locale conventions;
  no invented formatting style.
- RTL text direction comes from the app's locale handling (unchanged); formatters return
  plain strings, never layout.

## Usage scope

- Search result cards (photo, title, location, price) — FR-007.
- Tenant detail screen — FR-008.
- Saved list cards — FR-013.
- Filter sheet range labels — FR-002.

## Verification

Checked at all three breakpoints × EN/AR; Arabic prices/numbers render in Arabic-Indic
digits with no layout overflow (SC-007).
