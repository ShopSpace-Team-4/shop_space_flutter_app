# Contract: Media Upload

Branch `003-shop-listing-management` · Spec `spec.md` · Research `research.md` (D3) · Model `data-model.md`

## Purpose

Defines photo selection rules, the multipart upload request, the reorder/delete operations, and the
batch progress UX. Photos are the one place where the datasource talks multipart instead of JSON —
everything else follows `listings-api.md`.

## Client-side acceptance rules (D3)

| Rule | Value |
|---|---|
| Allowed types | PNG, JPG (`image/png`, `image/jpeg`) |
| Max size | ≤ 20 MB per file |
| Min count | none enforced — the app recommends ≥ 3 but never blocks (FR-002 photo picker) |
| Source | `image_picker` (gallery; camera optional per Figma) |

Violations are caught inline (`InvalidMediaFile`) and **never** sent to the backend. The picker
rejects non-PNG/JPG at selection where possible.

## Upload — `POST /listings/:id/media`

| Method & Path | Auth | Content-Type | Body |
|---|---|---|---|
| `POST /listings/:id/media` | Bearer + owner | `multipart/form-data` | repeated `photos` file fields (one per XFile) |

Dio `FormData` construction (in the datasource only — never the Cubit):

```dart
final form = FormData();
for (final file in files) {
  form.files.add(MapEntry(
    'photos',
    MultipartFile.fromFileSync(
      file.path,
      contentType: MediaType('image', file.mimeType?.split('/').last ?? 'jpeg'),
    ),
  ));
}
```

Single batched request for all picked photos (not one request per file) with one shared progress bar:

```dart
dio.post('/listings/$id/media', data: form, onSendProgress: (sent, total) { ... });
```

**Success `data`**: `{ "id": "...", "media": [ListingMedia] }` — the real `_id`s become the listing's
media; the staged `XFile` list is replaced by `ListingMedia` entries (create) or merged into
`existingMedia` (edit staging, not yet persisted).

**Errors → `Failure`**: 404 `ListingNotFound`; 403 `ListingNotOwned`; 4xx (rejected type/size)
`MediaUploadFailed`; transport/pipeline failures via the standard mapper. Never a raw exception.

## Batch progress (D3)

- One determinate `LinearProgressIndicator` driven by `onSendProgress` while the batch uploads.
- Progress state lives in `ListingFormCubit` (`isUploading`, `uploadProgress 0..1`); cancel is not
  offered this phase (a partial batch is harmless — see create/edit failure semantics below).

## Reorder — `PUT /listings/:id/media/reorder`

| Method & Path | Auth | Body | Success `data` |
|---|---|---|---|
| `PUT /listings/:id/media/reorder` | Bearer + owner | `MediaOrderRequest{ "media": [ { "mediaId": "<ListingMedia.id>", "sortOrder": 0 }, ... ] }` (full desired order) | `{ "id": "...", "media": [ListingMedia] }` (new order) |

`mediaId` is the `_id` returned by the upload/listing (`ListingMedia.id`). Send the complete final
order each time — not deltas. Errors → `MediaReorderFailed` / `ListingNotFound` / `ListingNotOwned`.

## Delete — `DELETE /listings/:id/media/:mediaId`

| Method & Path | Auth | Success `data` |
|---|---|---|
| `DELETE /listings/:id/media/:mediaId` | Bearer + owner | `{ "id": "...", "media": [ListingMedia] }` (remaining media) |

Deleting a photo in the edit flow is staged (`pendingDeletes`) and only executed on Save (D6). It is
only sent immediately when the whole listing is deleted (backend removes photos with the listing).
Errors → `MediaDeleteFailed` / `ListingNotFound` / `ListingNotOwned`.

## Failure semantics recap (from listing-form.md)

- **Create**: upload failure leaves the listing PENDING + localized message; photos can be retried via
  edit. Not all-or-nothing (D5).
- **Edit**: upload/reorder/delete failures inside Save → the whole Save rolls back ("nothing was
  saved"); next attempt re-fetches the fresh snapshot and re-applies all ops (D6).
