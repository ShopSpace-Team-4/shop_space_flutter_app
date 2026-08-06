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
  String get comingSoon => 'قريباً';

  @override
  String get routeNotFound => 'الصفحة غير موجودة';

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
  String get errorValidation =>
      'بعض البيانات المدخلة غير صحيحة. يرجى التحقق والمحاولة مرة أخرى.';

  @override
  String get errorEmailAlreadyRegistered =>
      'يوجد حساب مسجل بهذا البريد الإلكتروني بالفعل. جرّب تسجيل الدخول بدلاً من ذلك.';

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
  String get authLoginTitle => 'مرحباً بعودتك';

  @override
  String get authLoginSubmit => 'تسجيل الدخول';

  @override
  String get authLoginForgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get authLoginNoAccount => 'ليس لديك حساب؟';

  @override
  String get authLoginCreateAccount => 'إنشاء حساب';

  @override
  String get authSignupTitle => 'أنشئ حسابك';

  @override
  String get authSignupSubmit => 'إنشاء حساب';

  @override
  String get authSignupHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get authSignupSignIn => 'تسجيل الدخول';

  @override
  String get authOtpTitle => 'تحقق من بريدك الإلكتروني';

  @override
  String authOtpSubtitle(String email) {
    return 'أرسلنا رمزاً من 6 أرقام إلى $email';
  }

  @override
  String get authOtpFieldSemanticLabel => 'رمز التحقق من 6 أرقام';

  @override
  String get authOtpVerifySubmit => 'تحقق';

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
  String get authInvalidPhone => 'أدخل رقم هاتف صحيحاً';

  @override
  String get authPasswordRequired => 'أدخل كلمة المرور';

  @override
  String get authPasswordTooShort =>
      'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل';

  @override
  String get authPasswordRequiresLetter => 'يجب أن تحتوي كلمة المرور على حرف';

  @override
  String get authPasswordRequiresDigit => 'يجب أن تحتوي كلمة المرور على رقم';

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
}
