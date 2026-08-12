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

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingLetsGo.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Go'**
  String get onboardingLetsGo;

  /// No description provided for @onboardingPage1Title.
  ///
  /// In en, this message translates to:
  /// **'Find Your Perfect Space'**
  String get onboardingPage1Title;

  /// No description provided for @onboardingPage1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Browse 12,000+ verified commercial listings across Saudi Arabia.'**
  String get onboardingPage1Subtitle;

  /// No description provided for @onboardingPage2Title.
  ///
  /// In en, this message translates to:
  /// **'Connect with Landlords'**
  String get onboardingPage2Title;

  /// No description provided for @onboardingPage2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Chat directly, schedule visits, and close deals — all in one app.'**
  String get onboardingPage2Subtitle;

  /// No description provided for @onboardingPage3Title.
  ///
  /// In en, this message translates to:
  /// **'List & Rent'**
  String get onboardingPage3Title;

  /// No description provided for @onboardingPage3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'One account to manage your properties and rent spaces from others.'**
  String get onboardingPage3Subtitle;

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

  /// No description provided for @navSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get navSaved;

  /// No description provided for @navAdd.
  ///
  /// In en, this message translates to:
  /// **'Add listing'**
  String get navAdd;

  /// No description provided for @savedTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get savedTitle;

  /// No description provided for @savedEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No saved shops yet'**
  String get savedEmptyTitle;

  /// No description provided for @savedEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Shops you save will appear here so you can revisit them.'**
  String get savedEmptyMessage;

  /// No description provided for @savedSaveTooltip.
  ///
  /// In en, this message translates to:
  /// **'Save this shop'**
  String get savedSaveTooltip;

  /// No description provided for @savedUnsaveTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove from Saved'**
  String get savedUnsaveTooltip;

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

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name} 👋'**
  String homeGreeting(String name);

  /// No description provided for @homeGreetingFallback.
  ///
  /// In en, this message translates to:
  /// **'Hello 👋'**
  String get homeGreetingFallback;

  /// No description provided for @homeSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search shops, categories, or cities'**
  String get homeSearchHint;

  /// No description provided for @homeAdvisorTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Space Advisor'**
  String get homeAdvisorTitle;

  /// No description provided for @homeAdvisorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find your ideal space'**
  String get homeAdvisorSubtitle;

  /// No description provided for @homeCategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get homeCategoriesTitle;

  /// No description provided for @homeRecommendedTitle.
  ///
  /// In en, this message translates to:
  /// **'Spaces'**
  String get homeRecommendedTitle;

  /// No description provided for @homeSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get homeSeeAll;

  /// No description provided for @homeNearbyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nearby Listings'**
  String get homeNearbyTitle;

  /// No description provided for @homeEmptyRecommended.
  ///
  /// In en, this message translates to:
  /// **'No recommendations yet'**
  String get homeEmptyRecommended;

  /// No description provided for @homeEmptyNearby.
  ///
  /// In en, this message translates to:
  /// **'No nearby listings yet'**
  String get homeEmptyNearby;

  /// No description provided for @homeEmptyCategories.
  ///
  /// In en, this message translates to:
  /// **'No categories available'**
  String get homeEmptyCategories;

  /// No description provided for @homeRentPerYear.
  ///
  /// In en, this message translates to:
  /// **'{amount}/yr'**
  String homeRentPerYear(String amount);

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

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

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

  /// No description provided for @errorPhoneAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'An account with this phone already exists. Try signing in instead.'**
  String get errorPhoneAlreadyRegistered;

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

  /// No description provided for @errorGoogleSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not sign in with Google. Please try again.'**
  String get errorGoogleSignInFailed;

  /// No description provided for @errorRateLimited.
  ///
  /// In en, this message translates to:
  /// **'You\'re trying too often. Please wait a moment and try again.'**
  String get errorRateLimited;

  /// No description provided for @errorListingMetaUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the listing options. Please try again.'**
  String get errorListingMetaUnavailable;

  /// No description provided for @errorListingCreateFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t create the listing. Please try again.'**
  String get errorListingCreateFailed;

  /// No description provided for @errorListingUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save your changes. Please try again.'**
  String get errorListingUpdateFailed;

  /// No description provided for @errorListingStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t change the listing status. The current status was restored.'**
  String get errorListingStatusFailed;

  /// No description provided for @errorListingDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t delete the listing. Please try again.'**
  String get errorListingDeleteFailed;

  /// No description provided for @errorListingNotFound.
  ///
  /// In en, this message translates to:
  /// **'This listing no longer exists.'**
  String get errorListingNotFound;

  /// No description provided for @errorMediaUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t upload the photos. Please try again.'**
  String get errorMediaUploadFailed;

  /// No description provided for @errorMediaReorderFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reorder the photos. Please try again.'**
  String get errorMediaReorderFailed;

  /// No description provided for @errorMediaDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t remove this photo. Please try again.'**
  String get errorMediaDeleteFailed;

  /// No description provided for @errorListingNotOwned.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission to manage this listing.'**
  String get errorListingNotOwned;

  /// No description provided for @errorInvalidMediaFile.
  ///
  /// In en, this message translates to:
  /// **'Only PNG or JPG photos up to 20 MB are supported.'**
  String get errorInvalidMediaFile;

  /// No description provided for @errorPhotoLimitReached.
  ///
  /// In en, this message translates to:
  /// **'You can add up to 10 photos.'**
  String get errorPhotoLimitReached;

  /// No description provided for @errorSaveListingFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save this shop. Please try again.'**
  String get errorSaveListingFailed;

  /// No description provided for @errorUnsaveListingFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t remove this shop from Saved. Please try again.'**
  String get errorUnsaveListingFailed;

  /// No description provided for @errorSavedListingsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your saved shops. Please try again.'**
  String get errorSavedListingsLoadFailed;

  /// No description provided for @errorGoogleLinkFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t link your Google account. Please try again.'**
  String get errorGoogleLinkFailed;

  /// No description provided for @errorContactLaunchFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open a messaging app. Please try again.'**
  String get errorContactLaunchFailed;

  /// No description provided for @errorAdvisorChat.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t get an answer. Please try again.'**
  String get errorAdvisorChat;

  /// No description provided for @searchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search shops'**
  String get searchTitle;

  /// No description provided for @searchBarHint.
  ///
  /// In en, this message translates to:
  /// **'City, type, district…'**
  String get searchBarHint;

  /// No description provided for @searchBarClear.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get searchBarClear;

  /// No description provided for @searchOpenFilters.
  ///
  /// In en, this message translates to:
  /// **'Open filters'**
  String get searchOpenFilters;

  /// No description provided for @searchFilters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get searchFilters;

  /// No description provided for @searchFilterSort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get searchFilterSort;

  /// No description provided for @searchFilterCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get searchFilterCity;

  /// No description provided for @searchFilterDistrict.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get searchFilterDistrict;

  /// No description provided for @searchFilterCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get searchFilterCategory;

  /// No description provided for @searchFilterPriceRange.
  ///
  /// In en, this message translates to:
  /// **'Price range'**
  String get searchFilterPriceRange;

  /// No description provided for @searchFilterSizeRange.
  ///
  /// In en, this message translates to:
  /// **'Size range'**
  String get searchFilterSizeRange;

  /// No description provided for @searchFilterAmenities.
  ///
  /// In en, this message translates to:
  /// **'Amenities'**
  String get searchFilterAmenities;

  /// No description provided for @searchPriceMinLabel.
  ///
  /// In en, this message translates to:
  /// **'Min price'**
  String get searchPriceMinLabel;

  /// No description provided for @searchPriceMaxLabel.
  ///
  /// In en, this message translates to:
  /// **'Max price'**
  String get searchPriceMaxLabel;

  /// No description provided for @searchAreaMinLabel.
  ///
  /// In en, this message translates to:
  /// **'Min size'**
  String get searchAreaMinLabel;

  /// No description provided for @searchAreaMaxLabel.
  ///
  /// In en, this message translates to:
  /// **'Max size'**
  String get searchAreaMaxLabel;

  /// No description provided for @searchSortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get searchSortNewest;

  /// No description provided for @searchSortPriceAsc.
  ///
  /// In en, this message translates to:
  /// **'Price: low to high'**
  String get searchSortPriceAsc;

  /// No description provided for @searchSortPriceDesc.
  ///
  /// In en, this message translates to:
  /// **'Price: high to low'**
  String get searchSortPriceDesc;

  /// No description provided for @searchApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get searchApply;

  /// No description provided for @searchReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get searchReset;

  /// No description provided for @searchResetFilters.
  ///
  /// In en, this message translates to:
  /// **'Reset filters'**
  String get searchResetFilters;

  /// No description provided for @searchClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get searchClearAll;

  /// No description provided for @searchEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No shops match your filters'**
  String get searchEmptyTitle;

  /// No description provided for @searchEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Try removing some filters to see more results.'**
  String get searchEmptyMessage;

  /// No description provided for @searchEndOfList.
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached the end'**
  String get searchEndOfList;

  /// No description provided for @searchSelectShop.
  ///
  /// In en, this message translates to:
  /// **'Select a shop to view details'**
  String get searchSelectShop;

  /// No description provided for @searchAskAdvisor.
  ///
  /// In en, this message translates to:
  /// **'Ask the AI Space Advisor'**
  String get searchAskAdvisor;

  /// No description provided for @advisorTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Space Advisor'**
  String get advisorTitle;

  /// No description provided for @advisorStatus.
  ///
  /// In en, this message translates to:
  /// **'● Always available'**
  String get advisorStatus;

  /// No description provided for @advisorWelcome.
  ///
  /// In en, this message translates to:
  /// **'I\'m your AI business advisor. Ask me anything about finding, renting, or running a shop space.'**
  String get advisorWelcome;

  /// No description provided for @advisorTryAsking.
  ///
  /// In en, this message translates to:
  /// **'Try asking…'**
  String get advisorTryAsking;

  /// No description provided for @advisorExampleQuestion1.
  ///
  /// In en, this message translates to:
  /// **'What kind of business should I open in New Cairo?'**
  String get advisorExampleQuestion1;

  /// No description provided for @advisorExampleQuestion2.
  ///
  /// In en, this message translates to:
  /// **'What licenses should I consider?'**
  String get advisorExampleQuestion2;

  /// No description provided for @advisorExampleQuestion3.
  ///
  /// In en, this message translates to:
  /// **'I want shops for rent in Smouha suitable for a cafe'**
  String get advisorExampleQuestion3;

  /// No description provided for @advisorExampleQuestion4.
  ///
  /// In en, this message translates to:
  /// **'What is the difference between renting and buying a shop?'**
  String get advisorExampleQuestion4;

  /// No description provided for @advisorInputHint.
  ///
  /// In en, this message translates to:
  /// **'Ask the AI advisor…'**
  String get advisorInputHint;

  /// No description provided for @advisorSendTooltip.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get advisorSendTooltip;

  /// No description provided for @advisorThinking.
  ///
  /// In en, this message translates to:
  /// **'Thinking…'**
  String get advisorThinking;

  /// No description provided for @advisorSourcesTitle.
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get advisorSourcesTitle;

  /// No description provided for @advisorDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This information is provided for informational purposes only and does not constitute professional or legal advice.'**
  String get advisorDisclaimer;

  /// No description provided for @advisorRecommendedListings.
  ///
  /// In en, this message translates to:
  /// **'Recommended Listings'**
  String get advisorRecommendedListings;

  /// No description provided for @searchPriceRangeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Max price must be greater than min price'**
  String get searchPriceRangeInvalid;

  /// No description provided for @searchAreaRangeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Max size must be greater than min size'**
  String get searchAreaRangeInvalid;

  /// No description provided for @searchValueNegative.
  ///
  /// In en, this message translates to:
  /// **'Values can\'t be negative'**
  String get searchValueNegative;

  /// No description provided for @searchSaveTooltip.
  ///
  /// In en, this message translates to:
  /// **'Save this shop'**
  String get searchSaveTooltip;

  /// No description provided for @searchSavedTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove from Saved'**
  String get searchSavedTooltip;

  /// No description provided for @searchRangeSeparator.
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get searchRangeSeparator;

  /// No description provided for @searchFrom.
  ///
  /// In en, this message translates to:
  /// **'From {value}'**
  String searchFrom(String value);

  /// No description provided for @searchTo.
  ///
  /// In en, this message translates to:
  /// **'Up to {value}'**
  String searchTo(String value);

  /// No description provided for @searchRange.
  ///
  /// In en, this message translates to:
  /// **'{from} – {to}'**
  String searchRange(String from, String to);

  /// No description provided for @shopDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Shop details'**
  String get shopDetailTitle;

  /// No description provided for @shopDetailGalleryCounter.
  ///
  /// In en, this message translates to:
  /// **'{current} of {total}'**
  String shopDetailGalleryCounter(int current, int total);

  /// No description provided for @shopDetailContactLandlord.
  ///
  /// In en, this message translates to:
  /// **'Contact via WhatsApp'**
  String get shopDetailContactLandlord;

  /// No description provided for @shopDetailUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'No longer available'**
  String get shopDetailUnavailableTitle;

  /// No description provided for @shopDetailUnavailableMessage.
  ///
  /// In en, this message translates to:
  /// **'This shop is no longer available for rent.'**
  String get shopDetailUnavailableMessage;

  /// No description provided for @shopDetailReturnToResults.
  ///
  /// In en, this message translates to:
  /// **'Back to results'**
  String get shopDetailReturnToResults;

  /// No description provided for @whatsappContactMessage.
  ///
  /// In en, this message translates to:
  /// **'Hello, I\'m interested in the shop \'{title}\' in {city}, {district}.'**
  String whatsappContactMessage(String title, String city, String district);

  /// No description provided for @whatsappContactUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This shop\'s contact details aren\'t available right now.'**
  String get whatsappContactUnavailable;

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
  /// **'Verify code'**
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

  /// No description provided for @authOtpEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Check your email to find your code. It\'s valid for 10 minutes.'**
  String get authOtpEmailHint;

  /// No description provided for @authOtpEnterCode.
  ///
  /// In en, this message translates to:
  /// **'Enter verification code'**
  String get authOtpEnterCode;

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
  /// **'Needs a capital letter, a number, and one of @ \$ ! % * ? &'**
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

  /// No description provided for @profileLinkGoogle.
  ///
  /// In en, this message translates to:
  /// **'Link Google account'**
  String get profileLinkGoogle;

  /// No description provided for @profileLinkGoogleSuccess.
  ///
  /// In en, this message translates to:
  /// **'Google account linked.'**
  String get profileLinkGoogleSuccess;

  /// No description provided for @profileEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileEditProfile;

  /// No description provided for @profileEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get profileEditTitle;

  /// No description provided for @profileEditSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get profileEditSave;

  /// No description provided for @profileEditSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated.'**
  String get profileEditSuccess;

  /// No description provided for @profileVerification.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get profileVerification;

  /// No description provided for @profileVerificationVerified.
  ///
  /// In en, this message translates to:
  /// **'ID & Business verified'**
  String get profileVerificationVerified;

  /// No description provided for @profileVerificationNotVerified.
  ///
  /// In en, this message translates to:
  /// **'Not verified yet'**
  String get profileVerificationNotVerified;

  /// No description provided for @profileListingsStat.
  ///
  /// In en, this message translates to:
  /// **'Listings'**
  String get profileListingsStat;

  /// No description provided for @profileActiveListings.
  ///
  /// In en, this message translates to:
  /// **'{count} active listings'**
  String profileActiveListings(int count);

  /// No description provided for @profileSettingsRow.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profileSettingsRow;

  /// No description provided for @profileSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications, privacy'**
  String get profileSettingsSubtitle;

  /// No description provided for @profileRoleSwitchSuccess.
  ///
  /// In en, this message translates to:
  /// **'Active role updated'**
  String get profileRoleSwitchSuccess;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSectionAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsSectionAccount;

  /// No description provided for @settingsSectionNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsSectionNotifications;

  /// No description provided for @settingsSectionPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsSectionPrivacy;

  /// No description provided for @settingsEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get settingsEditProfile;

  /// No description provided for @settingsEditProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Name, photo, bio'**
  String get settingsEditProfileSubtitle;

  /// No description provided for @settingsChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get settingsChangePassword;

  /// No description provided for @settingsChangePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update or reset your password'**
  String get settingsChangePasswordSubtitle;

  /// No description provided for @settingsLinkGoogle.
  ///
  /// In en, this message translates to:
  /// **'Link Google account'**
  String get settingsLinkGoogle;

  /// No description provided for @settingsLinkGoogleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in faster with Google'**
  String get settingsLinkGoogleSubtitle;

  /// No description provided for @settingsNotifPush.
  ///
  /// In en, this message translates to:
  /// **'Push notifications'**
  String get settingsNotifPush;

  /// No description provided for @settingsNotifPushSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enquiries, messages'**
  String get settingsNotifPushSubtitle;

  /// No description provided for @settingsNotifEmail.
  ///
  /// In en, this message translates to:
  /// **'Email alerts'**
  String get settingsNotifEmail;

  /// No description provided for @settingsNotifEmailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly digest'**
  String get settingsNotifEmailSubtitle;

  /// No description provided for @settingsNotifSms.
  ///
  /// In en, this message translates to:
  /// **'SMS alerts'**
  String get settingsNotifSms;

  /// No description provided for @settingsNotifSmsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Critical only'**
  String get settingsNotifSmsSubtitle;

  /// No description provided for @settingsDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get settingsDeleteAccount;

  /// No description provided for @settingsDeleteAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Permanent action'**
  String get settingsDeleteAccountSubtitle;

  /// No description provided for @settingsSectionAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsSectionAppearance;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get settingsLanguageSheetTitle;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguageArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get settingsLanguageArabic;

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

  /// No description provided for @myListingsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Listings'**
  String get myListingsTitle;

  /// No description provided for @myListingsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No listings yet'**
  String get myListingsEmptyTitle;

  /// No description provided for @myListingsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'When you list a shop, it will appear here. Start by listing your first shop.'**
  String get myListingsEmptyMessage;

  /// No description provided for @myListingsListAShop.
  ///
  /// In en, this message translates to:
  /// **'List a shop'**
  String get myListingsListAShop;

  /// No description provided for @myListingsError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your listings. Please try again.'**
  String get myListingsError;

  /// No description provided for @myListingsNotPublic.
  ///
  /// In en, this message translates to:
  /// **'Not public yet'**
  String get myListingsNotPublic;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get statusAvailable;

  /// No description provided for @statusRented.
  ///
  /// In en, this message translates to:
  /// **'Rented'**
  String get statusRented;

  /// No description provided for @statusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get statusExpired;

  /// No description provided for @statusChangeTitle.
  ///
  /// In en, this message translates to:
  /// **'Change status'**
  String get statusChangeTitle;

  /// No description provided for @statusChangeSubmit.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get statusChangeSubmit;

  /// No description provided for @statusChangeSuccess.
  ///
  /// In en, this message translates to:
  /// **'Status updated'**
  String get statusChangeSuccess;

  /// No description provided for @detailNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get detailNotAvailable;

  /// No description provided for @detailFloor.
  ///
  /// In en, this message translates to:
  /// **'Floor'**
  String get detailFloor;

  /// No description provided for @detailGround.
  ///
  /// In en, this message translates to:
  /// **'Ground'**
  String get detailGround;

  /// No description provided for @detailArea.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get detailArea;

  /// No description provided for @detailAreaValue.
  ///
  /// In en, this message translates to:
  /// **'{area} m²'**
  String detailAreaValue(String area);

  /// No description provided for @detailAnnualRent.
  ///
  /// In en, this message translates to:
  /// **'Annual rent'**
  String get detailAnnualRent;

  /// No description provided for @detailAnnualRentWithVat.
  ///
  /// In en, this message translates to:
  /// **'Annual rent incl. VAT'**
  String get detailAnnualRentWithVat;

  /// No description provided for @detailAmenities.
  ///
  /// In en, this message translates to:
  /// **'Amenities'**
  String get detailAmenities;

  /// No description provided for @detailAvailableFrom.
  ///
  /// In en, this message translates to:
  /// **'Available from'**
  String get detailAvailableFrom;

  /// No description provided for @detailMinimumLease.
  ///
  /// In en, this message translates to:
  /// **'Minimum lease'**
  String get detailMinimumLease;

  /// No description provided for @detailSecurityDeposit.
  ///
  /// In en, this message translates to:
  /// **'Security deposit'**
  String get detailSecurityDeposit;

  /// No description provided for @detailMonths.
  ///
  /// In en, this message translates to:
  /// **'months'**
  String get detailMonths;

  /// No description provided for @detailFloors.
  ///
  /// In en, this message translates to:
  /// **'Floors'**
  String get detailFloors;

  /// No description provided for @detailFloorsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} floors'**
  String detailFloorsCount(int count);

  /// No description provided for @detailPerYear.
  ///
  /// In en, this message translates to:
  /// **'/year'**
  String get detailPerYear;

  /// No description provided for @detailMoreCount.
  ///
  /// In en, this message translates to:
  /// **'+{count} more'**
  String detailMoreCount(int count);

  /// No description provided for @detailDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get detailDescription;

  /// No description provided for @detailAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get detailAddress;

  /// No description provided for @detailCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get detailCategory;

  /// No description provided for @detailCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get detailCity;

  /// No description provided for @detailDistrict.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get detailDistrict;

  /// No description provided for @detailEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get detailEdit;

  /// No description provided for @detailDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get detailDelete;

  /// No description provided for @detailBackToMyListings.
  ///
  /// In en, this message translates to:
  /// **'My Listings'**
  String get detailBackToMyListings;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete listing'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete this listing and all of its photos. This can\'t be undone.'**
  String get deleteConfirmMessage;

  /// No description provided for @deleteConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteConfirmAction;

  /// No description provided for @deleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Listing deleted'**
  String get deleteSuccess;

  /// No description provided for @currencyPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'{currency}'**
  String currencyPlaceholder(Object currency);

  /// No description provided for @vatSuffix.
  ///
  /// In en, this message translates to:
  /// **'incl. VAT'**
  String get vatSuffix;

  /// No description provided for @becomeLandlordTitle.
  ///
  /// In en, this message translates to:
  /// **'Become a Landlord'**
  String get becomeLandlordTitle;

  /// No description provided for @becomeLandlordBody.
  ///
  /// In en, this message translates to:
  /// **'As a landlord you can list your shops, manage photos, and control pricing. Tenants will be able to contact you about your spaces.'**
  String get becomeLandlordBody;

  /// No description provided for @becomeLandlordConfirm.
  ///
  /// In en, this message translates to:
  /// **'Become a Landlord'**
  String get becomeLandlordConfirm;

  /// No description provided for @becomeLandlordDismissHint.
  ///
  /// In en, this message translates to:
  /// **'You can do this later from My Listings.'**
  String get becomeLandlordDismissHint;

  /// No description provided for @formTitleCreate.
  ///
  /// In en, this message translates to:
  /// **'List a shop'**
  String get formTitleCreate;

  /// No description provided for @formStepDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get formStepDetails;

  /// No description provided for @formStepPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get formStepPhotos;

  /// No description provided for @formStepPrice.
  ///
  /// In en, this message translates to:
  /// **'Price & lease'**
  String get formStepPrice;

  /// No description provided for @formStepReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get formStepReview;

  /// No description provided for @formStepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String formStepOf(int current, int total);

  /// No description provided for @formNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get formNext;

  /// No description provided for @formBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get formBack;

  /// No description provided for @formSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get formSubmit;

  /// No description provided for @formSubmitCreate.
  ///
  /// In en, this message translates to:
  /// **'Create listing'**
  String get formSubmitCreate;

  /// No description provided for @formFieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get formFieldTitle;

  /// No description provided for @formFieldTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Retail shop in Zamalek'**
  String get formFieldTitleHint;

  /// No description provided for @formTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a title'**
  String get formTitleRequired;

  /// No description provided for @formTitleTooLong.
  ///
  /// In en, this message translates to:
  /// **'Title must be at most {max} characters'**
  String formTitleTooLong(int max);

  /// No description provided for @formFieldCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get formFieldCategory;

  /// No description provided for @formCategoryRequired.
  ///
  /// In en, this message translates to:
  /// **'Select a category'**
  String get formCategoryRequired;

  /// No description provided for @formCategoryHint.
  ///
  /// In en, this message translates to:
  /// **'Select a category'**
  String get formCategoryHint;

  /// No description provided for @formFieldArea.
  ///
  /// In en, this message translates to:
  /// **'Area (sqm)'**
  String get formFieldArea;

  /// No description provided for @formAreaRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the area'**
  String get formAreaRequired;

  /// No description provided for @formAreaPositive.
  ///
  /// In en, this message translates to:
  /// **'Area must be greater than zero'**
  String get formAreaPositive;

  /// No description provided for @formFieldCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get formFieldCity;

  /// No description provided for @formCityRequired.
  ///
  /// In en, this message translates to:
  /// **'Select a city'**
  String get formCityRequired;

  /// No description provided for @formCityHint.
  ///
  /// In en, this message translates to:
  /// **'Select a city'**
  String get formCityHint;

  /// No description provided for @formFieldDistrict.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get formFieldDistrict;

  /// No description provided for @formDistrictRequired.
  ///
  /// In en, this message translates to:
  /// **'Select a district'**
  String get formDistrictRequired;

  /// No description provided for @formDistrictHint.
  ///
  /// In en, this message translates to:
  /// **'Select a district'**
  String get formDistrictHint;

  /// No description provided for @formFieldAddress.
  ///
  /// In en, this message translates to:
  /// **'Address (optional)'**
  String get formFieldAddress;

  /// No description provided for @formFieldDescription.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get formFieldDescription;

  /// No description provided for @formFieldAmenities.
  ///
  /// In en, this message translates to:
  /// **'Amenities'**
  String get formFieldAmenities;

  /// No description provided for @formAmenitiesHint.
  ///
  /// In en, this message translates to:
  /// **'Select any that apply'**
  String get formAmenitiesHint;

  /// No description provided for @formFieldFloors.
  ///
  /// In en, this message translates to:
  /// **'Number of floors (optional)'**
  String get formFieldFloors;

  /// No description provided for @formFieldFloorNumber.
  ///
  /// In en, this message translates to:
  /// **'Floor number'**
  String get formFieldFloorNumber;

  /// No description provided for @formFloorRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the floor number'**
  String get formFloorRequired;

  /// No description provided for @formFieldAvailableFrom.
  ///
  /// In en, this message translates to:
  /// **'Available from'**
  String get formFieldAvailableFrom;

  /// No description provided for @formAvailableFromRequired.
  ///
  /// In en, this message translates to:
  /// **'Choose a date'**
  String get formAvailableFromRequired;

  /// No description provided for @formFieldMinimumLease.
  ///
  /// In en, this message translates to:
  /// **'Minimum lease term'**
  String get formFieldMinimumLease;

  /// No description provided for @formFieldAnnualRent.
  ///
  /// In en, this message translates to:
  /// **'Annual rent (EGP)'**
  String get formFieldAnnualRent;

  /// No description provided for @formRentRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the annual rent'**
  String get formRentRequired;

  /// No description provided for @formRentPositive.
  ///
  /// In en, this message translates to:
  /// **'Annual rent must be greater than zero'**
  String get formRentPositive;

  /// No description provided for @formVatPreview.
  ///
  /// In en, this message translates to:
  /// **'Annual rent incl. VAT'**
  String get formVatPreview;

  /// No description provided for @formCurrencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get formCurrencyLabel;

  /// No description provided for @formFieldSecurityDeposit.
  ///
  /// In en, this message translates to:
  /// **'Security deposit (months)'**
  String get formFieldSecurityDeposit;

  /// No description provided for @formPhotoAdd.
  ///
  /// In en, this message translates to:
  /// **'Add photos'**
  String get formPhotoAdd;

  /// No description provided for @formPhotoMaxHint.
  ///
  /// In en, this message translates to:
  /// **'Up to 10 photos'**
  String get formPhotoMaxHint;

  /// No description provided for @formPhotoPickGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get formPhotoPickGallery;

  /// No description provided for @formPhotoPickCamera.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get formPhotoPickCamera;

  /// No description provided for @formPhotoRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get formPhotoRemove;

  /// No description provided for @formPhotoRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Adding at least 3 photos helps tenants understand your shop. This is a recommendation, not a requirement.'**
  String get formPhotoRecommendation;

  /// No description provided for @formPhotoProgress.
  ///
  /// In en, this message translates to:
  /// **'Uploading photos…'**
  String get formPhotoProgress;

  /// No description provided for @formPhotoCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 photo} other{{count} photos}}'**
  String formPhotoCount(num count);

  /// No description provided for @formCreatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Listing created'**
  String get formCreatedTitle;

  /// No description provided for @formCreatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your listing was created but is not public yet. Publish it from My Listings when you\'re ready.'**
  String get formCreatedMessage;

  /// No description provided for @formMetaRetryTitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load listing options'**
  String get formMetaRetryTitle;

  /// No description provided for @formMetaRetryMessage.
  ///
  /// In en, this message translates to:
  /// **'You need the options to continue. Check your connection and try again.'**
  String get formMetaRetryMessage;

  /// No description provided for @formTitleEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit listing'**
  String get formTitleEdit;

  /// No description provided for @formSubmitSave.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get formSubmitSave;

  /// No description provided for @formNothingSaved.
  ///
  /// In en, this message translates to:
  /// **'Nothing was saved'**
  String get formNothingSaved;

  /// No description provided for @formNothingSavedMessage.
  ///
  /// In en, this message translates to:
  /// **'None of your changes were published. Fix the issue and try saving again.'**
  String get formNothingSavedMessage;

  /// No description provided for @formPhotoNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get formPhotoNew;

  /// No description provided for @formPhotoRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed'**
  String get formPhotoRemoved;

  /// No description provided for @formPhotoReorderHint.
  ///
  /// In en, this message translates to:
  /// **'Press and hold to reorder'**
  String get formPhotoReorderHint;

  /// No description provided for @formPreloadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this listing'**
  String get formPreloadErrorTitle;

  /// No description provided for @formPreloadErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'You need the listing data to continue. Check your connection and try again.'**
  String get formPreloadErrorMessage;

  /// No description provided for @amenityParking.
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get amenityParking;

  /// No description provided for @amenitySecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get amenitySecurity;

  /// No description provided for @amenityAc.
  ///
  /// In en, this message translates to:
  /// **'Air conditioning'**
  String get amenityAc;
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
