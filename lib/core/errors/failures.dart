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

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.messageKey);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.messageKey);
}

class EmailAlreadyRegistered extends Failure {
  const EmailAlreadyRegistered(super.messageKey);
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
