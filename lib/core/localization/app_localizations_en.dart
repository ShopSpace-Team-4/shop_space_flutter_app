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
  String get loading => 'Loading...';

  @override
  String get emptyState => 'Nothing here yet';
}
