sealed class Failure {
  const Failure(this.messageKey);

  final String messageKey;
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.messageKey);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure(super.messageKey);
}

class OfflineFailure extends Failure {
  const OfflineFailure(super.messageKey);
}

class ServerFailure extends Failure {
  const ServerFailure(super.messageKey);
}

/// Fallback for a non-2xx response the pipeline couldn't attribute to a known
/// business code (any unrecognized 4xx). Surfaces a neutral, localized message
/// instead of a misleading validation prompt.
class GenericFailure extends Failure {
  const GenericFailure(super.messageKey);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.messageKey);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.messageKey);
}

class EmailAlreadyRegistered extends Failure {
  const EmailAlreadyRegistered(super.messageKey);
}

class PhoneAlreadyRegistered extends Failure {
  const PhoneAlreadyRegistered(super.messageKey);
}

class InvalidOtp extends Failure {
  const InvalidOtp(super.messageKey);
}

class OtpAttemptsExceeded extends Failure {
  const OtpAttemptsExceeded(super.messageKey);
}

class InvalidCredentials extends Failure {
  const InvalidCredentials(super.messageKey);
}

class EmailNotVerified extends Failure {
  const EmailNotVerified(super.messageKey);
}

class GoogleSignInCancelled extends Failure {
  const GoogleSignInCancelled(super.messageKey);
}

/// Google Sign-In failed for a non-cancel reason (client misconfiguration,
/// provider error, unknown/other codes). Surfaces a localized error instead of
/// an unhandled platform exception (contract `google-signin-flow.md`).
///
/// [description]/[details] carry the platform-supplied diagnostics (from
/// `GoogleSignInException`) for developers — they are debug-logged, never
/// rendered. End users keep the generic localized message.
class GoogleSignInFailed extends Failure {
  const GoogleSignInFailed(super.messageKey, {this.description, this.details});

  /// Human-readable platform failure description (e.g. "serverClientId must
  /// be provided on Android"). Diagnostic only.
  final String? description;

  /// Additional platform failure details. Diagnostic only.
  final Object? details;
}

class RateLimited extends Failure {
  const RateLimited(super.messageKey);
}

/// `PATCH /users/me/link-google` failed to link the Google account to the
/// existing password account (contract `contracts/google-signin-flow.md`).
/// Covers provider-side rejections (e.g. the Google account is already linked
/// to another user) as well as any other non-2xx on the link endpoint.
class GoogleLinkFailed extends Failure {
  const GoogleLinkFailed(super.messageKey);
}

class ListingMetaUnavailable extends Failure {
  const ListingMetaUnavailable(super.messageKey);
}

class ListingCreateFailed extends Failure {
  const ListingCreateFailed(super.messageKey);
}

class ListingUpdateFailed extends Failure {
  const ListingUpdateFailed(super.messageKey);
}

class ListingStatusFailed extends Failure {
  const ListingStatusFailed(super.messageKey);
}

class ListingDeleteFailed extends Failure {
  const ListingDeleteFailed(super.messageKey);
}

class ListingNotFound extends Failure {
  const ListingNotFound(super.messageKey);
}

class MediaUploadFailed extends Failure {
  const MediaUploadFailed(super.messageKey);
}

class MediaReorderFailed extends Failure {
  const MediaReorderFailed(super.messageKey);
}

class MediaDeleteFailed extends Failure {
  const MediaDeleteFailed(super.messageKey);
}

class ListingNotOwned extends Failure {
  const ListingNotOwned(super.messageKey);
}

class InvalidMediaFile extends Failure {
  const InvalidMediaFile(super.messageKey);
}

/// The landlord tried to stage more than the allowed photo count (Figma
/// `242:1713`: "Up to 10 photos"). Surfaces inline in the Photos step; the
/// file is never staged.
class PhotoLimitReached extends Failure {
  const PhotoLimitReached(super.messageKey);
}

/// A tenant tap on a heart failed to save the listing (`POST /listings/:id/save`
/// non-2xx). The surface must revert the optimistic `isSaved` flip and offer a
/// retry (contract `saved-listings.md` consistency protocol).
class SaveListingFailed extends Failure {
  const SaveListingFailed(super.messageKey);
}

/// A tenant tap on a filled heart failed to unsave the listing
/// (`DELETE /listings/:id/save` non-2xx). Revert the optimistic flip + retry.
class UnsaveListingFailed extends Failure {
  const UnsaveListingFailed(super.messageKey);
}

/// `GET /users/me/saved-listings` failed — the Saved screen shows a localized
/// error + retry (US5 scenario 4).
class SavedListingsLoadFailed extends Failure {
  const SavedListingsLoadFailed(super.messageKey);
}
