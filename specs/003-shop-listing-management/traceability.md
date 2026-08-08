# Spec Traceability: Shop Listing Management (Landlord Side)

Feature `003-shop-listing-management` · Phase 7 polish (T068) · Branch `003-shop-listing-management`

Maps every functional requirement (FR-001..FR-016) and success criterion (SC-001..SC-008) from
`spec.md` to its implementing file(s). All paths are under `lib/` unless stated. Verified by static
code audit (2026-08-08); the final analyze gate (`dart run tool/quality.dart`) is clean. Manual
smoke at 3 breakpoints × EN/AR is **pending — environment limitation** (no device/emulator and no
image input; consistent with T033/T048/T056/T063). See `gap-log.md`.

## Functional Requirements

| ID | Requirement (abridged) | Implementing files |
|---|---|---|
| FR-001 | Single "List a shop" entry; Become-a-Landlord sheet when `roles[]` lacks landlord; never gate on `activeRole` | `features/listing/presentation/screens/my_listings_screen.dart` (`_openCreateFlow`); `presentation/widgets/become_landlord_sheet.dart`; `core/router/app_router.dart` |
| FR-002 | On confirm: `addRole(landlord)` (fresh creds written by Phase 1), switch dashboard, route into create form, no re-login | `presentation/cubits/become_landlord_cubit.dart`; `features/user/repository/user_repository.dart` (reused); `my_listings_screen.dart` `onSuccess` → `/listing-form` |
| FR-003 | Multi-step create form: details → photos → price/lease → review | `presentation/screens/listing_form_screen.dart`; `presentation/widgets/listing_form_step_{details,photos,price,review}.dart`; `presentation/cubits/listing_form_cubit.dart` |
| FR-004 | Category/amenity options from `GET /listings/meta`; retryable state | `data/listing_datasource.dart` (`fetchMeta`); `listing_form_cubit.dart` (`fetchMeta`/`metaFailure`); `listing_form_screen.dart` (retry UI); `data/models/listing_meta.dart` |
| FR-005 | City + district chosen from dropdowns, not free text | `data/locality_options.dart`; `listing_form_step_details.dart` (city/district dropdowns) |
| FR-006 | New listing starts PENDING; explicit publish required | `repository/listing_repository_impl.dart` (`createListing`); `data/models/create_listing_request.dart`; `presentation/widgets/status_picker.dart` + `cubits/my_listings_cubit.dart` (`changeStatus`) |
| FR-007 | Photos: attach/remove/reorder, upload progress, PNG/JPG ≤20MB rejection, create uploads after creation, failure → stays PENDING + retry via edit | `listing_form_step_photos.dart`; `listing_form_cubit.dart` (`addPhoto`/`removePhoto`/`setPendingOrder`, `maxPhotoBytes`, `InvalidMediaFile`); `listing_datasource.dart` (`uploadMedia`, `onSendProgress`); `listing_repository_impl.dart` (`createListing` — non-all-or-nothing D5) |
| FR-008 | Review shows all data + VAT-inclusive rent (display only) | `listing_form_step_review.dart` (`_VatRow`); `listing_form_step_price.dart` (`_VatPreview`); `data/models/create_listing_request.dart` / `update_listing_request.dart` (never include `annualRentWithVat`) |
| FR-009 | My Listings view: photo/title/key details/status; reflects create/edit/status changes | `my_listings_screen.dart`; `presentation/widgets/listing_card.dart`; `my_listings_cubit.dart` (`loadList`/`loadDetail`/in-place status update + refresh); `presentation/widgets/listing_detail_pane.dart` |
| FR-010 | Edit same prefilled form; save never changes status; media buffered until Save | `listing_form_cubit.dart` (edit mode, staging); `listing_repository_impl.dart` (`saveEdit` strict protocol D6); `update_listing_request.dart` (no `status`); `listing_form_screen.dart` |
| FR-011 | Change status via picker; only AVAILABLE shows in marketplace (backend-driven) | `status_picker.dart`; `presentation/widgets/listing_status_badge.dart`; `my_listings_cubit.dart` (`changeStatus`, convergence on rejection). Marketplace visibility is Phase 3 scope — the app renders status only, never re-implements visibility (D4) |
| FR-012 | Delete own listing after explicit confirmation; removes listing + photos | `listing_detail_screen.dart` (`_confirmDelete`); `my_listings_screen.dart` (`_ExpandedPane._confirmDelete`); `my_listings_cubit.dart` (`deleteListing`) |
| FR-013 | Permission-sensitive UI reads `roles[]`, never `activeRole` | `my_listings_screen.dart` (`_openCreateFlow`: `session.roles.contains('landlord')`); `become_landlord_cubit.dart` (`session.updateRoles`) |
| FR-014 | Friendly localized errors + retry; duplicate submissions prevented | All three Cubits (`isSubmitting`/`isLoading` guards); `core/errors/failures.dart`; `core/errors/failure_messages.dart`; `core/errors/error_mapper.dart`; `core/errors/dio_failure.dart` |
| FR-015 | Responsive at 3 breakpoints; two-pane My Listings only on expanded; form single centered column; EN/AR RTL; no overflow | `my_listings_screen.dart` (`breakpointOf == expanded` → `_ExpandedPane` else `_CompactPane`); `listing_form_screen.dart` (single centered `ConstrainedBox` at every size); `core/responsive/window_size.dart`; `core/responsive/app_adaptive_shell.dart`; `core/localization/app_{en,ar}.arb` (216 keys, full parity) |
| FR-016 | Photos display in My Listings, edit flow, and review | `listing_card.dart` (`_Thumbnail`); `listing_detail_pane.dart` (`_MediaGallery` in `sortOrder`); `listing_form_step_photos.dart` (grid); `listing_form_step_review.dart` (`_PhotoOutcome`) |

## Success Criteria

| ID | Criterion (abridged) | Status / evidence |
|---|---|---|
| SC-001 | First-time tenant → published listing in <5 min, no re-login | Implemented (FR-001/002 chain + create → publish via picker). Verified by code audit; manual timing pending. |
| SC-002 | Every action succeeds or ends in friendly localized error + retry; no raw errors | Implemented — typed `Failure` pipeline only; all three Cubits catch `Failure` and unknown errors (`ServerFailure` fallback). No `DioException` reaches UI. |
| SC-003 | Created listing appears in My Listings; status changes reflected on refresh | `my_listings_cubit.dart`: `loadList` refresh after create; in-place summary/detail update + convergence re-fetch on rejected transitions (T062). |
| SC-004 | Photos added/removed/reordered persist; unsupported/oversized rejected clearly | `listing_form_cubit.addPhoto` validation; datasource upload/reorder/delete; `saveEdit` staged ops. |
| SC-005 | Only AVAILABLE in marketplace | Phase 3 scope — backend filters `status=AVAILABLE`; app renders status only (FR-011/D4). N/A this phase; no browse surface built. |
| SC-006 | Tenant upgraded → landlord; creds work on first action | `become_landlord_cubit` → `UserRepository.addRole` (Phase 1 writes fresh tokens via `SessionController.onTokensUpdated` before returning). |
| SC-007 | Options from live metadata, never hardcoded; retryable when unavailable | `listing_form_cubit.fetchMeta`; category/amenity dropdowns read `meta`; `metaFailure` retryable. (`locality_options.dart` is the documented exception — see gap log.) |
| SC-008 | Verified at 3 breakpoints × EN/AR; two-pane on widest; no overflow | Code-level audit passes (see T064/T065 notes); manual smoke pending (environment limitation). |

## Verification notes

- Breakpoint structure (T064): every listing screen branches on `breakpointOf(context)`; the only
  two-pane layout is My Listings on expanded; the form is a single centered column at every size
  (`maxWidth: expanded ? 720.w : 520.w`). No unbounded/list overflow patterns found (all scrollables
  are `SingleChildScrollView`/`ListView.builder`; the only fixed-height surfaces are the photo grid
  tiles and media gallery, both within scroll views).
- RTL/l10n (T065): `app_en.arb` and `app_ar.arb` share an identical 216-key set (0 missing, 0 extra);
  `flutter gen-l10n` output is up to date. Only literal user-visible strings in `lib/features/listing/`
  are the language-neutral tokens `EGP` (fixed currency) and `m²` (SI unit) — accepted as
  intentionally non-localized (T065 clarification, 2026-08-08). Locale-aware mirroring is native Flutter
  RTL; photo grid flows right-to-left via `Wrap`.
- Architecture (T066): no violations found (details in gap-log.md / audit below).
