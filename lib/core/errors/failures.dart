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

class RateLimited extends Failure {
  const RateLimited(super.messageKey);
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
