// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ShopSpace';

  @override
  String get commonBack => 'Back';

  @override
  String get navHome => 'Home';

  @override
  String get navProfile => 'Profile';

  @override
  String get navListings => 'Listings';

  @override
  String get navSearch => 'Search';

  @override
  String get navAdvisor => 'Advisor';

  @override
  String get navInquiries => 'Inquiries';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get routeNotFound => 'Page not found';

  @override
  String get authLogin => 'Sign in';

  @override
  String get authSignup => 'Sign up';

  @override
  String get authOtp => 'Verify OTP';

  @override
  String get authResetPassword => 'Reset password';

  @override
  String get placeholderBody =>
      'This section is under construction. Feature flows will arrive in a later phase.';

  @override
  String get retry => 'Retry';

  @override
  String get errorNetwork => 'Something went wrong. Please try again.';

  @override
  String get errorTimeout => 'The request timed out. Please try again.';

  @override
  String get errorOffline =>
      'You\'re offline. Check your connection and try again.';

  @override
  String get errorServer =>
      'Something went wrong on our side. Please try again later.';

  @override
  String get errorUnauthorized =>
      'Your session has expired. Please sign in again.';

  @override
  String get errorValidation =>
      'Some of the details you entered look incorrect. Please check and try again.';

  @override
  String get errorEmailAlreadyRegistered =>
      'An account with this email already exists. Try signing in instead.';

  @override
  String get errorInvalidOtp =>
      'The code you entered is incorrect or has expired. Try again.';

  @override
  String get errorOtpAttemptsExceeded =>
      'Too many incorrect attempts. Request a new code to try again.';

  @override
  String get errorInvalidCredentials => 'The email or password is incorrect.';

  @override
  String get errorEmailNotVerified =>
      'This account isn\'t verified yet. Enter the code we sent to your email to activate it.';

  @override
  String get errorGoogleSignInCancelled => 'Sign-in with Google was cancelled.';

  @override
  String get errorRateLimited =>
      'You\'re trying too often. Please wait a moment and try again.';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authFirstNameLabel => 'First name';

  @override
  String get authLastNameLabel => 'Last name';

  @override
  String get authPhoneLabel => 'Phone number';

  @override
  String get authCurrentPasswordLabel => 'Current password';

  @override
  String get authNewPasswordLabel => 'New password';

  @override
  String get authLoginTitle => 'Welcome back 👋';

  @override
  String get authLoginSubtitle => 'Sign in to your ShopSpace account';

  @override
  String get authLoginSubmit => 'Sign in';

  @override
  String get authLoginForgotPassword => 'Forgot your password?';

  @override
  String get authSignupTitle => 'Create account';

  @override
  String get authSignupSubtitle => 'One account for listing and renting';

  @override
  String get authSignupSubmit => 'Create account';

  @override
  String get authOr => 'or';

  @override
  String get authOtpTitle => 'Verify your email';

  @override
  String authOtpSubtitle(String email) {
    return 'We sent a 6-digit code to $email';
  }

  @override
  String get authOtpFieldSemanticLabel => '6-digit verification code';

  @override
  String get authOtpVerifySubmit => 'Verify';

  @override
  String get authOtpSuccess => 'Your email is verified. You can now sign in.';

  @override
  String get authOtpResend => 'Resend code';

  @override
  String authOtpResendIn(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String authOtpAttemptsRemaining(int count) {
    return '$count attempts remaining';
  }

  @override
  String get authOtpLocked =>
      'Too many incorrect attempts. Request a new code to try again.';

  @override
  String get authOtpRequestNewCode => 'Request a new code';

  @override
  String get authOtpCodeRequired => 'Enter the verification code';

  @override
  String get authOtpCodeLength => 'The code must be 6 digits';

  @override
  String get authForgotPasswordTitle => 'Forgot your password?';

  @override
  String get authForgotPasswordSubmit => 'Send reset code';

  @override
  String authForgotPasswordCheckEmail(String email) {
    return 'We sent a reset code to $email';
  }

  @override
  String get authResetPasswordTitle => 'Reset your password';

  @override
  String get authResetPasswordSubmit => 'Reset password';

  @override
  String get authResetPasswordSuccess =>
      'Your password has been reset. Sign in with your new password.';

  @override
  String get authGoogleButton => 'Continue with Google';

  @override
  String get authNameRequired => 'Enter your name';

  @override
  String get authInvalidEmail => 'Enter a valid email address';

  @override
  String get authInvalidPhone => 'Phone number must be 11 digits';

  @override
  String get authPasswordRequired => 'Enter your password';

  @override
  String get authPasswordTooShort => 'Password must be at least 8 characters';

  @override
  String get authPasswordTooLong => 'Password must be at most 20 characters';

  @override
  String get authPasswordStrength =>
      'Use characters with a capital letter, a number and one of @ \$ ! % * ? &';

  @override
  String get authCurrentPasswordRequired => 'Enter your current password';

  @override
  String get authBackToLogin => 'Back to sign in';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileChangePassword => 'Change password';

  @override
  String get profileSignOut => 'Sign out';

  @override
  String get changePasswordTitle => 'Change password';

  @override
  String get changePasswordSubmit => 'Update password';

  @override
  String get changePasswordSuccess => 'Password changed. Please sign in again.';

  @override
  String get activeRoleLabel => 'Active role';

  @override
  String get roleTenant => 'Tenant';

  @override
  String get roleLandlord => 'Landlord';

  @override
  String get loading => 'Loading...';

  @override
  String get emptyState => 'Nothing here yet';
}
