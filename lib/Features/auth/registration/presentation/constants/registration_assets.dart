// lib/Features/auth/registration/presentation/constants/registration_assets.dart
class RegistrationAssets {
  static const String logo = 'assets/svg/Logo.svg';
  static const String userIcon = 'assets/svg/User.svg';
  static const String storeIcon = 'assets/svg/12. Storefront.svg';
  static const String phoneIcon = 'assets/svg/08. Phone.svg';
  static const String passwordIcon = 'assets/svg/09. Password.svg';
  static const String eyeIcon = 'assets/svg/eye.svg';
  static const String eyeSlashIcon = 'assets/svg/10. EyeSlash.svg';
  static const String mapPinIcon = 'assets/svg/MapPinLine.svg';
  static const String downArrowIcon = 'assets/svg/downrowsvg.svg';
  static const String navigationAddIcon = 'assets/svg/navigation_add.svg';
}

// lib/Features/auth/registration/presentation/constants/registration_dimensions.dart
class RegistrationDimensions {
  static const double initialSheetSize = 0.66;
  static const double minSheetSize = 0.66;
  static const double maxSheetSize = 0.66;
  static const double topGap = 25.0;
  static const double logoGap = 16.0;
  static const double titleGap = 8.0;
  static const double iconPadding = 10.0;
  static const double horizontalPadding = 20.0;
  static const double sheetBorderRadius = 20.0;
  static const double fieldGap = 5.0;
  static const double sectionGap = 10.0;
  static const double tabBarHeight = 24.0;
  static const double imageUploadButtonWidth = 115.0;
  static const double imageUploadButtonHeight = 55.0;
}

// lib/Features/auth/registration/presentation/constants/registration_strings.dart
class RegistrationStrings {
  // Header
  static const String appBarTitle = 'تسجيل دخول';
  static const String createNewAccount = 'انشاء حساب جديد';
  static const String welcomeDescription = 
    'مرحبا بك في منصة توصيل، قم بادخال المعلومات ادناه و سيتم انشاء حساب لمتجرك بعد الموافقة و التفعيل.';
  
  // Tabs
  static const String userInfoTab = 'معلومات الحساب';
  static const String deliveryInfoTab = 'معلومات التوصيل';
  
  // User Info Fields
  static const String ownerName = 'أسم صاحب المتجر';
  static const String ownerNameHint = 'مثال: "محمد حسين"';
  static const String storeName = 'اسم المتجر';
  static const String storeNameHint = 'مثال: "معرض الأخوين"';
  static const String userName = 'اسم المستخدم';
  static const String userNameHint = 'مثال: "ahmad_store"';
  static const String phoneNumber = 'رقم هاتف المتجر';
  static const String phoneHint = '07xx Xxx Xxx';
  static const String storeLogo = 'شعار / صورة المتجر';
  static const String uploadImage = 'تحميل الصورة';
  static const String password = 'الرمز السري';
  static const String passwordHint = 'أدخل كلمة المرور';
  static const String confirmPassword = 'تأكيد الرمز السري';
  static const String confirmPasswordHint = 'أعد كتابة كلمة المرور';
  
  // Delivery Info
  static const String deliveryAddress = 'عنوان إستلام البضاعة';
  static const String governorate = 'المحافظة';
  static const String governorateHint = 'ابحث عن المحافظة... مثال: \'بغداد\'';
  static const String zone = 'المنطقة';
  static const String zoneHint = 'ابحث عن المنطقة...';
  static const String nearestPoint = 'اقرب نقطة دالة';
  static const String nearestPointHint = 'مثال: \'قرب مطعم الخيمة\'';
  static const String locationOnMap = 'الموقع على الخريطة';
  static const String selectLocation = 'تحديد الموقع';
  static const String locationSelected = 'تم تحديد الموقع';
  static const String editLocation = 'اضغط للتعديل';
  static const String addLocation = 'إضافة موقع';
  
  // Buttons
  static const String next = 'التالي';
  static const String previous = 'السابق';
  static const String createAccount = 'إنشاء الحساب';
  static const String haveAccount = 'هل لديك حساب؟';
  static const String login = 'تسجيل الدخول';
  
  // Messages
  static const String imageUploadSuccess = 'تم رفع الصورة بنجاح';
  static const String imageUploadError = 'فشل في رفع الصورة';
  static const String registrationSuccess = 'مرحباً بك في توصيل! تم تفعيل حسابك بنجاح';
  static const String registrationPending = 
    'تم تسجيل حسابك بنجاح! سيتم مراجعة طلبك والموافقة عليه خلال 24 ساعة.';
  static const String exitConfirmation = 'سيتم فقدان جميع البيانات المدخلة. هل تريد الخروج؟';
  static const String confirmExit = 'تأكيد الخروج';
  static const String cancel = 'إلغاء';
  static const String exit = 'خروج';
}