/// One slot of the edit form's staged photo order (data-model.md §3.2/§4,
/// contract `listing-form.md` §Photo staging). A slot is either an existing
/// server media (`mediaId` set, `clientId` null) or a not-yet-uploaded add
/// (`clientId` set, `mediaId` null). `pendingOrder` is the desired final media
/// order with adds in position. Lives only in the form/repository layer — never
/// serialized or sent directly.
class StagedMediaEntry {
  const StagedMediaEntry.existing(String this.mediaId) : clientId = null;

  const StagedMediaEntry.add(int this.clientId) : mediaId = null;

  /// The existing media's `ListingMedia.id` (null for a pending add).
  final String? mediaId;

  /// The local `PendingMedia.clientId` of a not-yet-uploaded add (null for an
  /// existing media).
  final int? clientId;

  bool get isAdd => clientId != null;
}
