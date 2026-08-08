// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'شوب سبيس';

  @override
  String get commonBack => 'رجوع';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navProfile => 'الملف الشخصي';

  @override
  String get navListings => 'القوائم';

  @override
  String get navSearch => 'البحث';

  @override
  String get navAdvisor => 'المستشار';

  @override
  String get navInquiries => 'الاستفسارات';

  @override
  String get navSaved => 'المحفوظة';

  @override
  String get navAdd => 'إضافة قائمة';

  @override
  String get savedTitle => 'المحفوظة';

  @override
  String get comingSoon => 'قريباً';

  @override
  String get routeNotFound => 'الصفحة غير موجودة';

  @override
  String homeGreeting(String name) {
    return 'مرحباً، $name 👋';
  }

  @override
  String get homeGreetingFallback => 'مرحباً 👋';

  @override
  String get homeSearchHint => 'ابحث عن محلات، فئات، أو مدن';

  @override
  String get homeAdvisorTitle => 'مستشار المساحات الذكي';

  @override
  String get homeAdvisorSubtitle => 'ابحث عن مساحتك المثالية';

  @override
  String get homeCategoriesTitle => 'الفئات';

  @override
  String get homeRecommendedTitle => 'المساحات';

  @override
  String get homeSeeAll => 'عرض الكل';

  @override
  String get homeNearbyTitle => 'قوائم قريبة';

  @override
  String get homeEmptyRecommended => 'لا توجد توصيات بعد';

  @override
  String get homeEmptyNearby => 'لا توجد قوائم قريبة بعد';

  @override
  String get homeEmptyCategories => 'لا توجد فئات متاحة';

  @override
  String homeRentPerYear(String amount) {
    return '$amount/سنة';
  }

  @override
  String get authLogin => 'تسجيل الدخول';

  @override
  String get authSignup => 'إنشاء حساب';

  @override
  String get authOtp => 'التحقق من الرمز';

  @override
  String get authResetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get placeholderBody =>
      'هذا القسم قيد الإنشاء. سيتم تفعيل الميزات في مرحلة لاحقة.';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get errorNetwork => 'حدث خطأ ما. يرجى المحاولة مرة أخرى.';

  @override
  String get errorTimeout => 'انتهت مهلة الطلب. يرجى المحاولة مرة أخرى.';

  @override
  String get errorOffline =>
      'أنت غير متصل بالإنترنت. تحقق من الاتصال وحاول مرة أخرى.';

  @override
  String get errorServer => 'حدث خطأ من طرفنا. يرجى المحاولة لاحقاً.';

  @override
  String get errorUnauthorized =>
      'انتهت صلاحية جلستك. يرجى تسجيل الدخول مرة أخرى.';

  @override
  String get errorGeneric => 'حدث خطأ ما. يرجى المحاولة مرة أخرى.';

  @override
  String get errorValidation =>
      'بعض البيانات المدخلة غير صحيحة. يرجى التحقق والمحاولة مرة أخرى.';

  @override
  String get errorEmailAlreadyRegistered =>
      'يوجد حساب مسجل بهذا البريد الإلكتروني بالفعل. جرّب تسجيل الدخول بدلاً من ذلك.';

  @override
  String get errorPhoneAlreadyRegistered =>
      'يوجد حساب مسجل بهذا الرقم بالفعل. جرّب تسجيل الدخول بدلاً من ذلك.';

  @override
  String get errorInvalidOtp =>
      'الرمز الذي أدخلته غير صحيح أو منتهي الصلاحية. حاول مرة أخرى.';

  @override
  String get errorOtpAttemptsExceeded =>
      'عدد كبير جداً من المحاولات الخاطئة. اطلب رمزاً جديداً للمحاولة مرة أخرى.';

  @override
  String get errorInvalidCredentials =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة.';

  @override
  String get errorEmailNotVerified =>
      'لم يتم التحقق من هذا الحساب بعد. أدخل الرمز الذي أرسلناه إلى بريدك الإلكتروني لتفعيله.';

  @override
  String get errorGoogleSignInCancelled => 'تم إلغاء تسجيل الدخول عبر Google.';

  @override
  String get errorRateLimited =>
      'تحاول كثيراً. يرجى الانتظار قليلاً ثم المحاولة مرة أخرى.';

  @override
  String get errorListingMetaUnavailable =>
      'تعذر تحميل خيارات القائمة. يرجى المحاولة مرة أخرى.';

  @override
  String get errorListingCreateFailed =>
      'تعذر إنشاء القائمة. يرجى المحاولة مرة أخرى.';

  @override
  String get errorListingUpdateFailed =>
      'تعذر حفظ التغييرات. يرجى المحاولة مرة أخرى.';

  @override
  String get errorListingStatusFailed =>
      'تعذر تغيير حالة القائمة. تمت استعادة الحالة الحالية.';

  @override
  String get errorListingDeleteFailed =>
      'تعذر حذف القائمة. يرجى المحاولة مرة أخرى.';

  @override
  String get errorListingNotFound => 'هذه القائمة لم تعد موجودة.';

  @override
  String get errorMediaUploadFailed =>
      'تعذر رفع الصور. يرجى المحاولة مرة أخرى.';

  @override
  String get errorMediaReorderFailed =>
      'تعذر إعادة ترتيب الصور. يرجى المحاولة مرة أخرى.';

  @override
  String get errorMediaDeleteFailed =>
      'تعذر إزالة هذه الصورة. يرجى المحاولة مرة أخرى.';

  @override
  String get errorListingNotOwned => 'ليس لديك صلاحية إدارة هذه القائمة.';

  @override
  String get errorInvalidMediaFile =>
      'يُسمح فقط بصور PNG أو JPG بحجم يصل إلى 20 ميجابايت.';

  @override
  String get errorPhotoLimitReached => 'يمكنك إضافة ما يصل إلى 10 صور.';

  @override
  String get authEmailLabel => 'البريد الإلكتروني';

  @override
  String get authPasswordLabel => 'كلمة المرور';

  @override
  String get authFirstNameLabel => 'الاسم الأول';

  @override
  String get authLastNameLabel => 'اسم العائلة';

  @override
  String get authPhoneLabel => 'رقم الهاتف';

  @override
  String get authCurrentPasswordLabel => 'كلمة المرور الحالية';

  @override
  String get authNewPasswordLabel => 'كلمة المرور الجديدة';

  @override
  String get authLoginTitle => 'مرحباً بعودتك 👋';

  @override
  String get authLoginSubtitle => 'سجّل الدخول إلى حسابك في شوب سبيس';

  @override
  String get authLoginSubmit => 'تسجيل الدخول';

  @override
  String get authLoginForgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get authSignupTitle => 'أنشئ حسابك';

  @override
  String get authSignupSubtitle => 'حساب واحد للعرض والاستئجار';

  @override
  String get authSignupSubmit => 'إنشاء حساب';

  @override
  String get authOr => 'أو';

  @override
  String get authOtpTitle => 'تحقق من بريدك الإلكتروني';

  @override
  String authOtpSubtitle(String email) {
    return 'أرسلنا رمزاً من 6 أرقام إلى $email';
  }

  @override
  String get authOtpFieldSemanticLabel => 'رمز التحقق من 6 أرقام';

  @override
  String get authOtpVerifySubmit => 'تحقق من الرمز';

  @override
  String get authOtpSuccess =>
      'تم التحقق من بريدك الإلكتروني. يمكنك الآن تسجيل الدخول.';

  @override
  String get authOtpResend => 'إعادة إرسال الرمز';

  @override
  String authOtpResendIn(int seconds) {
    return 'أعد الإرسال خلال $seconds ث';
  }

  @override
  String authOtpAttemptsRemaining(int count) {
    return 'متبقي $count محاولات';
  }

  @override
  String get authOtpLocked =>
      'عدد كبير جداً من المحاولات الخاطئة. اطلب رمزاً جديداً للمحاولة مرة أخرى.';

  @override
  String get authOtpRequestNewCode => 'اطلب رمزاً جديداً';

  @override
  String get authOtpCodeRequired => 'أدخل رمز التحقق';

  @override
  String get authOtpCodeLength => 'يجب أن يتكون الرمز من 6 أرقام';

  @override
  String get authOtpEmailHint =>
      'تحقق من بريدك الإلكتروني للعثور على رمزك. الرمز صالح لمدة 10 دقائق.';

  @override
  String get authOtpEnterCode => 'أدخل رمز التحقق';

  @override
  String get authForgotPasswordTitle => 'هل نسيت كلمة المرور؟';

  @override
  String get authForgotPasswordSubmit => 'إرسال رمز إعادة التعيين';

  @override
  String authForgotPasswordCheckEmail(String email) {
    return 'أرسلنا رمز إعادة التعيين إلى $email';
  }

  @override
  String get authResetPasswordTitle => 'إعادة تعيين كلمة المرور';

  @override
  String get authResetPasswordSubmit => 'إعادة تعيين كلمة المرور';

  @override
  String get authResetPasswordSuccess =>
      'تمت إعادة تعيين كلمة المرور. سجّل الدخول بكلمة المرور الجديدة.';

  @override
  String get authGoogleButton => 'المتابعة عبر Google';

  @override
  String get authNameRequired => 'أدخل اسمك';

  @override
  String get authInvalidEmail => 'أدخل بريداً إلكترونياً صحيحاً';

  @override
  String get authInvalidPhone => 'يجب أن يتكون رقم الهاتف من 11 رقماً';

  @override
  String get authPasswordRequired => 'أدخل كلمة المرور';

  @override
  String get authPasswordTooShort =>
      'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل';

  @override
  String get authPasswordTooLong => 'يجب ألا تزيد كلمة المرور عن 20 حرفاً';

  @override
  String get authPasswordStrength =>
      'يلزم حرف كبير ورقم وأحد الرموز @ \$ ! % * ? &';

  @override
  String get authCurrentPasswordRequired => 'أدخل كلمة المرور الحالية';

  @override
  String get authBackToLogin => 'العودة إلى تسجيل الدخول';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get profileChangePassword => 'تغيير كلمة المرور';

  @override
  String get profileSignOut => 'تسجيل الخروج';

  @override
  String get changePasswordTitle => 'تغيير كلمة المرور';

  @override
  String get changePasswordSubmit => 'تحديث كلمة المرور';

  @override
  String get changePasswordSuccess =>
      'تم تغيير كلمة المرور. يرجى تسجيل الدخول مرة أخرى.';

  @override
  String get activeRoleLabel => 'الدور النشط';

  @override
  String get roleTenant => 'مستأجر';

  @override
  String get roleLandlord => 'مالك';

  @override
  String get loading => 'جارٍ التحميل...';

  @override
  String get emptyState => 'لا يوجد شيء هنا بعد';

  @override
  String get myListingsTitle => 'قوائمي';

  @override
  String get myListingsEmptyTitle => 'لا توجد قوائم بعد';

  @override
  String get myListingsEmptyMessage =>
      'عندما تعرض محلك، سيظهر هنا. ابدأ بعرض أول محل لك.';

  @override
  String get myListingsListAShop => 'اعرض محلاً';

  @override
  String get myListingsError => 'تعذر تحميل قوائمك. يرجى المحاولة مرة أخرى.';

  @override
  String get myListingsNotPublic => 'غير متاح للعامة بعد';

  @override
  String get statusPending => 'قيد الانتظار';

  @override
  String get statusAvailable => 'متاح';

  @override
  String get statusRented => 'مؤجَّر';

  @override
  String get statusExpired => 'منتهي';

  @override
  String get statusChangeTitle => 'تغيير الحالة';

  @override
  String get statusChangeSubmit => 'حفظ';

  @override
  String get statusChangeSuccess => 'تم تحديث الحالة';

  @override
  String get detailNotAvailable => 'غير متاح';

  @override
  String get detailFloor => 'الطابق';

  @override
  String get detailGround => 'الأرضي';

  @override
  String get detailArea => 'المساحة';

  @override
  String detailAreaValue(String area) {
    return '$area م²';
  }

  @override
  String get detailAnnualRent => 'الإيجار السنوي';

  @override
  String get detailAnnualRentWithVat => 'الإيجار السنوي شامل الضريبة';

  @override
  String get detailAmenities => 'المرافق';

  @override
  String get detailAvailableFrom => 'متاح من';

  @override
  String get detailMinimumLease => 'الحد الأدنى للإيجار';

  @override
  String get detailSecurityDeposit => 'التأمين';

  @override
  String get detailMonths => 'أشهر';

  @override
  String get detailFloors => 'عدد الطوابق';

  @override
  String get detailDescription => 'الوصف';

  @override
  String get detailAddress => 'العنوان';

  @override
  String get detailCategory => 'الفئة';

  @override
  String get detailCity => 'المدينة';

  @override
  String get detailDistrict => 'الحي';

  @override
  String get detailEdit => 'تعديل';

  @override
  String get detailDelete => 'حذف';

  @override
  String get detailBackToMyListings => 'قوائمي';

  @override
  String get commonCancel => 'إلغاء';

  @override
  String get deleteConfirmTitle => 'حذف القائمة';

  @override
  String get deleteConfirmMessage =>
      'سيتم حذف هذه القائمة وجميع صورها نهائياً. لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get deleteConfirmAction => 'حذف';

  @override
  String get deleteSuccess => 'تم حذف القائمة';

  @override
  String currencyPlaceholder(Object currency) {
    return '$currency';
  }

  @override
  String get vatSuffix => 'شامل الضريبة';

  @override
  String get becomeLandlordTitle => 'كن مالكاً';

  @override
  String get becomeLandlordBody =>
      'بصفتك مالكاً يمكنك عرض محلاتك وإدارة الصور والتحكم في الأسعار. سيتمكن المستأجرون من التواصل معك بشأن مساحاتك.';

  @override
  String get becomeLandlordConfirm => 'كن مالكاً';

  @override
  String get becomeLandlordDismissHint => 'يمكنك القيام بذلك لاحقاً من قوائمي.';

  @override
  String get formTitleCreate => 'اعرض محلاً';

  @override
  String get formStepDetails => 'التفاصيل';

  @override
  String get formStepPhotos => 'الصور';

  @override
  String get formStepPrice => 'السعر والإيجار';

  @override
  String get formStepReview => 'المراجعة';

  @override
  String formStepOf(int current, int total) {
    return 'الخطوة $current من $total';
  }

  @override
  String get formNext => 'التالي';

  @override
  String get formBack => 'رجوع';

  @override
  String get formSubmit => 'إرسال';

  @override
  String get formSubmitCreate => 'إنشاء القائمة';

  @override
  String get formFieldTitle => 'العنوان';

  @override
  String get formFieldTitleHint => 'مثال: محل تجاري في الزمالك';

  @override
  String get formTitleRequired => 'أدخل العنوان';

  @override
  String formTitleTooLong(int max) {
    return 'يجب ألا يتجاوز العنوان $max حرفاً';
  }

  @override
  String get formFieldCategory => 'الفئة';

  @override
  String get formCategoryRequired => 'اختر الفئة';

  @override
  String get formCategoryHint => 'اختر الفئة';

  @override
  String get formFieldArea => 'المساحة (م²)';

  @override
  String get formAreaRequired => 'أدخل المساحة';

  @override
  String get formAreaPositive => 'يجب أن تكون المساحة أكبر من صفر';

  @override
  String get formFieldCity => 'المدينة';

  @override
  String get formCityRequired => 'اختر المدينة';

  @override
  String get formCityHint => 'اختر المدينة';

  @override
  String get formFieldDistrict => 'الحي';

  @override
  String get formDistrictRequired => 'اختر الحي';

  @override
  String get formDistrictHint => 'اختر الحي';

  @override
  String get formFieldAddress => 'العنوان (اختياري)';

  @override
  String get formFieldDescription => 'الوصف (اختياري)';

  @override
  String get formFieldAmenities => 'المرافق';

  @override
  String get formAmenitiesHint => 'اختر ما ينطبق';

  @override
  String get formFieldFloors => 'عدد الطوابق (اختياري)';

  @override
  String get formFieldFloorNumber => 'رقم الطابق';

  @override
  String get formFloorRequired => 'أدخل رقم الطابق';

  @override
  String get formFieldAvailableFrom => 'متاح من';

  @override
  String get formAvailableFromRequired => 'اختر تاريخاً';

  @override
  String get formFieldMinimumLease => 'الحد الأدنى لمدة الإيجار';

  @override
  String get formFieldAnnualRent => 'الإيجار السنوي (جنيه)';

  @override
  String get formRentRequired => 'أدخل الإيجار السنوي';

  @override
  String get formRentPositive => 'يجب أن يكون الإيجار السنوي أكبر من صفر';

  @override
  String get formVatPreview => 'الإيجار السنوي شامل الضريبة';

  @override
  String get formCurrencyLabel => 'العملة';

  @override
  String get formFieldSecurityDeposit => 'التأمين (أشهر)';

  @override
  String get formPhotoAdd => 'أضف صوراً';

  @override
  String get formPhotoMaxHint => 'حتى 10 صور';

  @override
  String get formPhotoPickGallery => 'اختر من المعرض';

  @override
  String get formPhotoPickCamera => 'التقط صورة';

  @override
  String get formPhotoRemove => 'إزالة';

  @override
  String get formPhotoRecommendation =>
      'إضافة 3 صور على الأقل تساعد المستأجرين على فهم محلك. هذا مجرد توصية وليس شرطاً.';

  @override
  String get formPhotoProgress => 'جارٍ رفع الصور…';

  @override
  String formPhotoCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count صور',
      one: 'صورة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get formCreatedTitle => 'تم إنشاء القائمة';

  @override
  String get formCreatedMessage =>
      'تم إنشاء قائمتك لكنها غير متاحة للعامة بعد. انشرها من قوائمي عندما تكون جاهزاً.';

  @override
  String get formMetaRetryTitle => 'تعذر تحميل خيارات القائمة';

  @override
  String get formMetaRetryMessage =>
      'تحتاج إلى الخيارات للمتابعة. تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get formTitleEdit => 'تعديل القائمة';

  @override
  String get formSubmitSave => 'حفظ التغييرات';

  @override
  String get formNothingSaved => 'لم يُحفظ شيء';

  @override
  String get formNothingSavedMessage =>
      'لم تُنشر أي من تغييراتك. أصلح المشكلة وحاول الحفظ مرة أخرى.';

  @override
  String get formPhotoNew => 'جديد';

  @override
  String get formPhotoRemoved => 'محذوف';

  @override
  String get formPhotoReorderHint => 'اضغط مع الاستمرار لإعادة الترتيب';

  @override
  String get formPreloadErrorTitle => 'تعذر تحميل هذه القائمة';

  @override
  String get formPreloadErrorMessage =>
      'تحتاج إلى بيانات القائمة للمتابعة. تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get amenityParking => 'موقف سيارات';

  @override
  String get amenitySecurity => 'أمن';

  @override
  String get amenityAc => 'تكييف';
}
