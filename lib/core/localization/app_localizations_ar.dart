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
  String get loading => 'جارٍ التحميل...';

  @override
  String get emptyState => 'لا يوجد شيء هنا بعد';
}
