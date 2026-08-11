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
  String get navSaved => 'Saved';

  @override
  String get navAdd => 'Add listing';

  @override
  String get savedTitle => 'Saved';

  @override
  String get savedEmptyTitle => 'No saved shops yet';

  @override
  String get savedEmptyMessage =>
      'Shops you save will appear here so you can revisit them.';

  @override
  String get savedSaveTooltip => 'Save this shop';

  @override
  String get savedUnsaveTooltip => 'Remove from Saved';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get routeNotFound => 'Page not found';

  @override
  String homeGreeting(String name) {
    return 'Hello, $name 👋';
  }

  @override
  String get homeGreetingFallback => 'Hello 👋';

  @override
  String get homeSearchHint => 'Search shops, categories, or cities';

  @override
  String get homeAdvisorTitle => 'AI Space Advisor';

  @override
  String get homeAdvisorSubtitle => 'Find your ideal space';

  @override
  String get homeCategoriesTitle => 'Categories';

  @override
  String get homeRecommendedTitle => 'Spaces';

  @override
  String get homeSeeAll => 'See all';

  @override
  String get homeNearbyTitle => 'Nearby Listings';

  @override
  String get homeEmptyRecommended => 'No recommendations yet';

  @override
  String get homeEmptyNearby => 'No nearby listings yet';

  @override
  String get homeEmptyCategories => 'No categories available';

  @override
  String homeRentPerYear(String amount) {
    return '$amount/yr';
  }

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
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorValidation =>
      'Some of the details you entered look incorrect. Please check and try again.';

  @override
  String get errorEmailAlreadyRegistered =>
      'An account with this email already exists. Try signing in instead.';

  @override
  String get errorPhoneAlreadyRegistered =>
      'An account with this phone already exists. Try signing in instead.';

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
  String get errorGoogleSignInFailed =>
      'Could not sign in with Google. Please try again.';

  @override
  String get errorRateLimited =>
      'You\'re trying too often. Please wait a moment and try again.';

  @override
  String get errorListingMetaUnavailable =>
      'Couldn\'t load the listing options. Please try again.';

  @override
  String get errorListingCreateFailed =>
      'Couldn\'t create the listing. Please try again.';

  @override
  String get errorListingUpdateFailed =>
      'Couldn\'t save your changes. Please try again.';

  @override
  String get errorListingStatusFailed =>
      'Couldn\'t change the listing status. The current status was restored.';

  @override
  String get errorListingDeleteFailed =>
      'Couldn\'t delete the listing. Please try again.';

  @override
  String get errorListingNotFound => 'This listing no longer exists.';

  @override
  String get errorMediaUploadFailed =>
      'Couldn\'t upload the photos. Please try again.';

  @override
  String get errorMediaReorderFailed =>
      'Couldn\'t reorder the photos. Please try again.';

  @override
  String get errorMediaDeleteFailed =>
      'Couldn\'t remove this photo. Please try again.';

  @override
  String get errorListingNotOwned =>
      'You don\'t have permission to manage this listing.';

  @override
  String get errorInvalidMediaFile =>
      'Only PNG or JPG photos up to 20 MB are supported.';

  @override
  String get errorPhotoLimitReached => 'You can add up to 10 photos.';

  @override
  String get errorSaveListingFailed =>
      'Couldn\'t save this shop. Please try again.';

  @override
  String get errorUnsaveListingFailed =>
      'Couldn\'t remove this shop from Saved. Please try again.';

  @override
  String get errorSavedListingsLoadFailed =>
      'Couldn\'t load your saved shops. Please try again.';

  @override
  String get errorGoogleLinkFailed =>
      'Couldn\'t link your Google account. Please try again.';

  @override
  String get errorContactLaunchFailed =>
      'Couldn\'t open a messaging app. Please try again.';

  @override
  String get errorAdvisorChat => 'Couldn\'t get an answer. Please try again.';

  @override
  String get searchTitle => 'Search shops';

  @override
  String get searchBarHint => 'City, type, district…';

  @override
  String get searchBarClear => 'Clear search';

  @override
  String get searchOpenFilters => 'Open filters';

  @override
  String get searchFilters => 'Filters';

  @override
  String get searchFilterSort => 'Sort';

  @override
  String get searchFilterCity => 'City';

  @override
  String get searchFilterDistrict => 'District';

  @override
  String get searchFilterCategory => 'Category';

  @override
  String get searchFilterPriceRange => 'Price range';

  @override
  String get searchFilterSizeRange => 'Size range';

  @override
  String get searchFilterAmenities => 'Amenities';

  @override
  String get searchPriceMinLabel => 'Min price';

  @override
  String get searchPriceMaxLabel => 'Max price';

  @override
  String get searchAreaMinLabel => 'Min size';

  @override
  String get searchAreaMaxLabel => 'Max size';

  @override
  String get searchSortNewest => 'Newest';

  @override
  String get searchSortPriceAsc => 'Price: low to high';

  @override
  String get searchSortPriceDesc => 'Price: high to low';

  @override
  String get searchApply => 'Apply';

  @override
  String get searchReset => 'Reset';

  @override
  String get searchResetFilters => 'Reset filters';

  @override
  String get searchClearAll => 'Clear all';

  @override
  String get searchEmptyTitle => 'No shops match your filters';

  @override
  String get searchEmptyMessage =>
      'Try removing some filters to see more results.';

  @override
  String get searchEndOfList => 'You\'ve reached the end';

  @override
  String get searchSelectShop => 'Select a shop to view details';

  @override
  String get searchAskAdvisor => 'Ask the AI Space Advisor';

  @override
  String get advisorTitle => 'AI Space Advisor';

  @override
  String get advisorStatus => '● Always available';

  @override
  String get advisorWelcome =>
      'I\'m your AI business advisor. Ask me anything about finding, renting, or running a shop space.';

  @override
  String get advisorTryAsking => 'Try asking…';

  @override
  String get advisorExampleQuestion1 =>
      'What kind of business should I open in New Cairo?';

  @override
  String get advisorExampleQuestion2 => 'What licenses should I consider?';

  @override
  String get advisorExampleQuestion3 =>
      'I want shops for rent in Smouha suitable for a cafe';

  @override
  String get advisorExampleQuestion4 =>
      'What is the difference between renting and buying a shop?';

  @override
  String get advisorInputHint => 'Ask the AI advisor…';

  @override
  String get advisorSendTooltip => 'Send';

  @override
  String get advisorThinking => 'Thinking…';

  @override
  String get advisorSourcesTitle => 'Sources';

  @override
  String get advisorDisclaimer =>
      'This information is provided for informational purposes only and does not constitute professional or legal advice.';

  @override
  String get advisorRecommendedListings => 'Recommended Listings';

  @override
  String get searchPriceRangeInvalid =>
      'Max price must be greater than min price';

  @override
  String get searchAreaRangeInvalid => 'Max size must be greater than min size';

  @override
  String get searchValueNegative => 'Values can\'t be negative';

  @override
  String get searchSaveTooltip => 'Save this shop';

  @override
  String get searchSavedTooltip => 'Remove from Saved';

  @override
  String get searchRangeSeparator => 'to';

  @override
  String searchFrom(String value) {
    return 'From $value';
  }

  @override
  String searchTo(String value) {
    return 'Up to $value';
  }

  @override
  String searchRange(String from, String to) {
    return '$from – $to';
  }

  @override
  String get shopDetailTitle => 'Shop details';

  @override
  String shopDetailGalleryCounter(int current, int total) {
    return '$current of $total';
  }

  @override
  String get shopDetailContactLandlord => 'Contact via WhatsApp';

  @override
  String get shopDetailUnavailableTitle => 'No longer available';

  @override
  String get shopDetailUnavailableMessage =>
      'This shop is no longer available for rent.';

  @override
  String get shopDetailReturnToResults => 'Back to results';

  @override
  String whatsappContactMessage(String title, String city, String district) {
    return 'Hello, I\'m interested in the shop \'$title\' in $city, $district.';
  }

  @override
  String get whatsappContactUnavailable =>
      'This shop\'s contact details aren\'t available right now.';

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
  String get authOtpVerifySubmit => 'Verify code';

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
  String get authOtpEmailHint =>
      'Check your email to find your code. It\'s valid for 10 minutes.';

  @override
  String get authOtpEnterCode => 'Enter verification code';

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
      'Needs a capital letter, a number, and one of @ \$ ! % * ? &';

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
  String get profileLinkGoogle => 'Link Google account';

  @override
  String get profileLinkGoogleSuccess => 'Google account linked.';

  @override
  String get profileEditProfile => 'Edit Profile';

  @override
  String get profileEditTitle => 'Edit profile';

  @override
  String get profileEditSave => 'Save';

  @override
  String get profileEditSuccess => 'Profile updated.';

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

  @override
  String get myListingsTitle => 'My Listings';

  @override
  String get myListingsEmptyTitle => 'No listings yet';

  @override
  String get myListingsEmptyMessage =>
      'When you list a shop, it will appear here. Start by listing your first shop.';

  @override
  String get myListingsListAShop => 'List a shop';

  @override
  String get myListingsError =>
      'Couldn\'t load your listings. Please try again.';

  @override
  String get myListingsNotPublic => 'Not public yet';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusAvailable => 'Available';

  @override
  String get statusRented => 'Rented';

  @override
  String get statusExpired => 'Expired';

  @override
  String get statusChangeTitle => 'Change status';

  @override
  String get statusChangeSubmit => 'Save';

  @override
  String get statusChangeSuccess => 'Status updated';

  @override
  String get detailNotAvailable => 'Not available';

  @override
  String get detailFloor => 'Floor';

  @override
  String get detailGround => 'Ground';

  @override
  String get detailArea => 'Area';

  @override
  String detailAreaValue(String area) {
    return '$area m²';
  }

  @override
  String get detailAnnualRent => 'Annual rent';

  @override
  String get detailAnnualRentWithVat => 'Annual rent incl. VAT';

  @override
  String get detailAmenities => 'Amenities';

  @override
  String get detailAvailableFrom => 'Available from';

  @override
  String get detailMinimumLease => 'Minimum lease';

  @override
  String get detailSecurityDeposit => 'Security deposit';

  @override
  String get detailMonths => 'months';

  @override
  String get detailFloors => 'Floors';

  @override
  String detailFloorsCount(int count) {
    return '$count floors';
  }

  @override
  String get detailPerYear => '/year';

  @override
  String detailMoreCount(int count) {
    return '+$count more';
  }

  @override
  String get detailDescription => 'Description';

  @override
  String get detailAddress => 'Address';

  @override
  String get detailCategory => 'Category';

  @override
  String get detailCity => 'City';

  @override
  String get detailDistrict => 'District';

  @override
  String get detailEdit => 'Edit';

  @override
  String get detailDelete => 'Delete';

  @override
  String get detailBackToMyListings => 'My Listings';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get deleteConfirmTitle => 'Delete listing';

  @override
  String get deleteConfirmMessage =>
      'This will permanently delete this listing and all of its photos. This can\'t be undone.';

  @override
  String get deleteConfirmAction => 'Delete';

  @override
  String get deleteSuccess => 'Listing deleted';

  @override
  String currencyPlaceholder(Object currency) {
    return '$currency';
  }

  @override
  String get vatSuffix => 'incl. VAT';

  @override
  String get becomeLandlordTitle => 'Become a Landlord';

  @override
  String get becomeLandlordBody =>
      'As a landlord you can list your shops, manage photos, and control pricing. Tenants will be able to contact you about your spaces.';

  @override
  String get becomeLandlordConfirm => 'Become a Landlord';

  @override
  String get becomeLandlordDismissHint =>
      'You can do this later from My Listings.';

  @override
  String get formTitleCreate => 'List a shop';

  @override
  String get formStepDetails => 'Details';

  @override
  String get formStepPhotos => 'Photos';

  @override
  String get formStepPrice => 'Price & lease';

  @override
  String get formStepReview => 'Review';

  @override
  String formStepOf(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get formNext => 'Next';

  @override
  String get formBack => 'Back';

  @override
  String get formSubmit => 'Submit';

  @override
  String get formSubmitCreate => 'Create listing';

  @override
  String get formFieldTitle => 'Title';

  @override
  String get formFieldTitleHint => 'e.g. Retail shop in Zamalek';

  @override
  String get formTitleRequired => 'Enter a title';

  @override
  String formTitleTooLong(int max) {
    return 'Title must be at most $max characters';
  }

  @override
  String get formFieldCategory => 'Category';

  @override
  String get formCategoryRequired => 'Select a category';

  @override
  String get formCategoryHint => 'Select a category';

  @override
  String get formFieldArea => 'Area (sqm)';

  @override
  String get formAreaRequired => 'Enter the area';

  @override
  String get formAreaPositive => 'Area must be greater than zero';

  @override
  String get formFieldCity => 'City';

  @override
  String get formCityRequired => 'Select a city';

  @override
  String get formCityHint => 'Select a city';

  @override
  String get formFieldDistrict => 'District';

  @override
  String get formDistrictRequired => 'Select a district';

  @override
  String get formDistrictHint => 'Select a district';

  @override
  String get formFieldAddress => 'Address (optional)';

  @override
  String get formFieldDescription => 'Description (optional)';

  @override
  String get formFieldAmenities => 'Amenities';

  @override
  String get formAmenitiesHint => 'Select any that apply';

  @override
  String get formFieldFloors => 'Number of floors (optional)';

  @override
  String get formFieldFloorNumber => 'Floor number';

  @override
  String get formFloorRequired => 'Enter the floor number';

  @override
  String get formFieldAvailableFrom => 'Available from';

  @override
  String get formAvailableFromRequired => 'Choose a date';

  @override
  String get formFieldMinimumLease => 'Minimum lease term';

  @override
  String get formFieldAnnualRent => 'Annual rent (EGP)';

  @override
  String get formRentRequired => 'Enter the annual rent';

  @override
  String get formRentPositive => 'Annual rent must be greater than zero';

  @override
  String get formVatPreview => 'Annual rent incl. VAT';

  @override
  String get formCurrencyLabel => 'Currency';

  @override
  String get formFieldSecurityDeposit => 'Security deposit (months)';

  @override
  String get formPhotoAdd => 'Add photos';

  @override
  String get formPhotoMaxHint => 'Up to 10 photos';

  @override
  String get formPhotoPickGallery => 'Choose from gallery';

  @override
  String get formPhotoPickCamera => 'Take a photo';

  @override
  String get formPhotoRemove => 'Remove';

  @override
  String get formPhotoRecommendation =>
      'Adding at least 3 photos helps tenants understand your shop. This is a recommendation, not a requirement.';

  @override
  String get formPhotoProgress => 'Uploading photos…';

  @override
  String formPhotoCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count photos',
      one: '1 photo',
    );
    return '$_temp0';
  }

  @override
  String get formCreatedTitle => 'Listing created';

  @override
  String get formCreatedMessage =>
      'Your listing was created but is not public yet. Publish it from My Listings when you\'re ready.';

  @override
  String get formMetaRetryTitle => 'Couldn\'t load listing options';

  @override
  String get formMetaRetryMessage =>
      'You need the options to continue. Check your connection and try again.';

  @override
  String get formTitleEdit => 'Edit listing';

  @override
  String get formSubmitSave => 'Save changes';

  @override
  String get formNothingSaved => 'Nothing was saved';

  @override
  String get formNothingSavedMessage =>
      'None of your changes were published. Fix the issue and try saving again.';

  @override
  String get formPhotoNew => 'New';

  @override
  String get formPhotoRemoved => 'Removed';

  @override
  String get formPhotoReorderHint => 'Press and hold to reorder';

  @override
  String get formPreloadErrorTitle => 'Couldn\'t load this listing';

  @override
  String get formPreloadErrorMessage =>
      'You need the listing data to continue. Check your connection and try again.';

  @override
  String get amenityParking => 'Parking';

  @override
  String get amenitySecurity => 'Security';

  @override
  String get amenityAc => 'Air conditioning';
}
