import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'ShopSpace'**
  String get appTitle;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navListings.
  ///
  /// In en, this message translates to:
  /// **'Listings'**
  String get navListings;

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @navAdvisor.
  ///
  /// In en, this message translates to:
  /// **'Advisor'**
  String get navAdvisor;

  /// No description provided for @navInquiries.
  ///
  /// In en, this message translates to:
  /// **'Inquiries'**
  String get navInquiries;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @routeNotFound.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get routeNotFound;

  /// No description provided for @authLogin.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authLogin;

  /// No description provided for @authSignup.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get authSignup;

  /// No description provided for @authOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get authOtp;

  /// No description provided for @authResetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get authResetPassword;

  /// No description provided for @placeholderBody.
  ///
  /// In en, this message translates to:
  /// **'This section is under construction. Feature flows will arrive in a later phase.'**
  String get placeholderBody;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorNetwork;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'The request timed out. Please try again.'**
  String get errorTimeout;

  /// No description provided for @errorOffline.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. Check your connection and try again.'**
  String get errorOffline;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong on our side. Please try again later.'**
  String get errorServer;

  /// No description provided for @errorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please sign in again.'**
  String get errorUnauthorized;

  /// No description provided for @errorValidation.
  ///
  /// In en, this message translates to:
  /// **'Some of the details you entered look incorrect. Please check and try again.'**
  String get errorValidation;

  /// No description provided for @errorEmailAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'An account with this email already exists. Try signing in instead.'**
  String get errorEmailAlreadyRegistered;

  /// No description provided for @errorInvalidOtp.
  ///
  /// In en, this message translates to:
  /// **'The code you entered is incorrect or has expired. Try again.'**
  String get errorInvalidOtp;

  /// No description provided for @errorOtpAttemptsExceeded.
  ///
  /// In en, this message translates to:
  /// **'Too many incorrect attempts. Request a new code to try again.'**
  String get errorOtpAttemptsExceeded;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'The email or password is incorrect.'**
  String get errorInvalidCredentials;

  /// No description provided for @errorEmailNotVerified.
  ///
  /// In en, this message translates to:
  /// **'This account isn\'t verified yet. Enter the code we sent to your email to activate it.'**
  String get errorEmailNotVerified;

  /// No description provided for @errorGoogleSignInCancelled.
  ///
  /// In en, this message translates to:
  /// **'Sign-in with Google was cancelled.'**
  String get errorGoogleSignInCancelled;

  /// No description provided for @errorRateLimited.
  ///
  /// In en, this message translates to:
  /// **'You\'re trying too often. Please wait a moment and try again.'**
  String get errorRateLimited;

  /// No description provided for @authEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmailLabel;

  /// No description provided for @authPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordLabel;

  /// No description provided for @authFirstNameLabel.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get authFirstNameLabel;

  /// No description provided for @authLastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get authLastNameLabel;

  /// No description provided for @authPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get authPhoneLabel;

  /// No description provided for @authCurrentPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get authCurrentPasswordLabel;

  /// No description provided for @authNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get authNewPasswordLabel;

  /// No description provided for @authLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back 👋'**
  String get authLoginTitle;

  /// No description provided for @authLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your ShopSpace account'**
  String get authLoginSubtitle;

  /// No description provided for @authLoginSubmit.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authLoginSubmit;

  /// No description provided for @authLoginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get authLoginForgotPassword;

  /// No description provided for @authSignupTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authSignupTitle;

  /// No description provided for @authSignupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'One account for listing and renting'**
  String get authSignupSubtitle;

  /// No description provided for @authSignupSubmit.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authSignupSubmit;

  /// No description provided for @authOr.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get authOr;

  /// No description provided for @authOtpTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your email'**
  String get authOtpTitle;

  /// No description provided for @authOtpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit code to {email}'**
  String authOtpSubtitle(String email);

  /// No description provided for @authOtpFieldSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'6-digit verification code'**
  String get authOtpFieldSemanticLabel;

  /// No description provided for @authOtpVerifySubmit.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get authOtpVerifySubmit;

  /// No description provided for @authOtpSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your email is verified. You can now sign in.'**
  String get authOtpSuccess;

  /// No description provided for @authOtpResend.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get authOtpResend;

  /// No description provided for @authOtpResendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds}s'**
  String authOtpResendIn(int seconds);

  /// No description provided for @authOtpAttemptsRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count} attempts remaining'**
  String authOtpAttemptsRemaining(int count);

  /// No description provided for @authOtpLocked.
  ///
  /// In en, this message translates to:
  /// **'Too many incorrect attempts. Request a new code to try again.'**
  String get authOtpLocked;

  /// No description provided for @authOtpRequestNewCode.
  ///
  /// In en, this message translates to:
  /// **'Request a new code'**
  String get authOtpRequestNewCode;

  /// No description provided for @authOtpCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the verification code'**
  String get authOtpCodeRequired;

  /// No description provided for @authOtpCodeLength.
  ///
  /// In en, this message translates to:
  /// **'The code must be 6 digits'**
  String get authOtpCodeLength;

  /// No description provided for @authForgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get authForgotPasswordTitle;

  /// No description provided for @authForgotPasswordSubmit.
  ///
  /// In en, this message translates to:
  /// **'Send reset code'**
  String get authForgotPasswordSubmit;

  /// No description provided for @authForgotPasswordCheckEmail.
  ///
  /// In en, this message translates to:
  /// **'We sent a reset code to {email}'**
  String authForgotPasswordCheckEmail(String email);

  /// No description provided for @authResetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get authResetPasswordTitle;

  /// No description provided for @authResetPasswordSubmit.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get authResetPasswordSubmit;

  /// No description provided for @authResetPasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your password has been reset. Sign in with your new password.'**
  String get authResetPasswordSuccess;

  /// No description provided for @authGoogleButton.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authGoogleButton;

  /// No description provided for @authNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get authNameRequired;

  /// No description provided for @authInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get authInvalidEmail;

  /// No description provided for @authInvalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone number must be 11 digits'**
  String get authInvalidPhone;

  /// No description provided for @authPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get authPasswordRequired;

  /// No description provided for @authPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get authPasswordTooShort;

  /// No description provided for @authPasswordTooLong.
  ///
  /// In en, this message translates to:
  /// **'Password must be at most 20 characters'**
  String get authPasswordTooLong;

  /// No description provided for @authPasswordStrength.
  ///
  /// In en, this message translates to:
  /// **'Use 8-20 characters with a capital letter, a number and one of @ \$ ! % * ? &'**
  String get authPasswordStrength;

  /// No description provided for @authCurrentPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password'**
  String get authCurrentPasswordRequired;

  /// No description provided for @authBackToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to sign in'**
  String get authBackToLogin;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get profileChangePassword;

  /// No description provided for @profileSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get profileSignOut;

  /// No description provided for @changePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePasswordTitle;

  /// No description provided for @changePasswordSubmit.
  ///
  /// In en, this message translates to:
  /// **'Update password'**
  String get changePasswordSubmit;

  /// No description provided for @changePasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password changed. Please sign in again.'**
  String get changePasswordSuccess;

  /// No description provided for @activeRoleLabel.
  ///
  /// In en, this message translates to:
  /// **'Active role'**
  String get activeRoleLabel;

  /// No description provided for @roleTenant.
  ///
  /// In en, this message translates to:
  /// **'Tenant'**
  String get roleTenant;

  /// No description provided for @roleLandlord.
  ///
  /// In en, this message translates to:
  /// **'Landlord'**
  String get roleLandlord;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @emptyState.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get emptyState;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
