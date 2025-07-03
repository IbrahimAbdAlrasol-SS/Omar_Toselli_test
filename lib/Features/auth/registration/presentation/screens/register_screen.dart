import 'package:Tosell/core/config/routes/app_router.dart';
import 'package:Tosell/core/utils/extensions/GlobalToast.dart';
import 'package:Tosell/core/utils/extensions/extensions.dart';
import 'package:Tosell/core/utils/helpers/SharedPreferencesHelper.dart';
import 'package:Tosell/core/widgets/Others/CustomAppBar.dart';
import 'package:Tosell/features/auth/login/data/provider/auth_provider.dart';
import 'package:Tosell/features/auth/login/presentation/constants/login_dimensions.dart';
import 'package:Tosell/features/auth/registration/presentation/screens/delivery_info_tab.dart';
import 'package:Tosell/features/auth/registration/presentation/screens/user_info_tab.dart';
import 'package:Tosell/features/auth/registration/presentation/widgets/build_background.dart';
import 'package:Tosell/features/profile/data/models/zone.dart';
import 'package:gap/gap.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  bool _isSubmitting = false;
  bool _canNavigateToSecondTab = false;
  final GlobalKey<UserInfoTabState> _userInfoTabKey =
      GlobalKey<UserInfoTabState>();
  final GlobalKey<DeliveryInfoTabState> _deliveryInfoTabKey =
      GlobalKey<DeliveryInfoTabState>();

  String? fullName;
  String? brandName;
  String? userName;
  String? phoneNumber;
  String? password;
  String? brandImg;

  List<Zone> selectedZones = [];
  double? latitude;
  double? longitude;
  String? nearestLandmark;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      // منع التنقل للتاب الثاني إذا لم يكن مسموحاً
      if (_tabController.index == 1 && !_canNavigateToSecondTab) {
        _tabController.animateTo(0);
        return;
      }

      if (_tabController.index != _currentIndex) {
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _goToNextTab() {
    if (_currentIndex < _tabController.length - 1) {
      // السماح بالتنقل للتاب الثاني عند الضغط على زر التالي
      setState(() {
        _canNavigateToSecondTab = true;
      });
      _tabController.animateTo(_currentIndex + 1);
    }
  }

  void _updateUserInfo({
    String? fullName,
    String? brandName,
    String? userName,
    String? phoneNumber,
    String? password,
    String? brandImg,
  }) {
    setState(() {
      if (fullName != null) this.fullName = fullName;
      if (brandName != null) this.brandName = brandName;
      if (userName != null) this.userName = userName;
      if (phoneNumber != null) this.phoneNumber = phoneNumber;
      if (password != null) this.password = password;
      if (brandImg != null) this.brandImg = brandImg;
    });

    print('📝 تحديث بيانات المستخدم:');
    print('   الاسم: ${this.fullName}');
    print('   المتجر: ${this.brandName}');
    print('   اسم المستخدم: ${this.userName}');
    print('   الهاتف: ${this.phoneNumber}');
    print(
        '   الصورة: ${this.brandImg?.isNotEmpty == true ? 'موجودة' : 'غير موجودة'}');
  }

  /// ✅ تحديث المناطق والإحداثيات من DeliveryInfoTab
  void _updateZonesWithLocation({
    required List<Zone> zones,
    double? latitude,
    double? longitude,
    String? nearestLandmark,
  }) {
    setState(() {
      selectedZones = zones;
      this.latitude = latitude;
      this.longitude = longitude;
      this.nearestLandmark = nearestLandmark;
    });
  }

  bool _validateData() {
    if (fullName?.isEmpty ?? true) {
      GlobalToast.show(
          context: context,
          message: 'اسم صاحب المتجر مطلوب',
          backgroundColor:
              const Color(0xFFD54444)); // Error color from light theme
      _tabController.animateTo(0);
      return false;
    }
    if (brandName?.isEmpty ?? true) {
      GlobalToast.show(
          context: context,
          message: 'اسم المتجر مطلوب',
          backgroundColor:
              const Color(0xFFD54444)); // Error color from light theme
      _tabController.animateTo(0);
      return false;
    }
    if (userName?.isEmpty ?? true) {
      GlobalToast.show(
          context: context,
          message: 'اسم المستخدم مطلوب',
          backgroundColor: Colors.red);
      _tabController.animateTo(0);
      return false;
    }
    if (phoneNumber?.isEmpty ?? true) {
      GlobalToast.show(
          context: context,
          message: 'رقم الهاتف مطلوب',
          backgroundColor: Colors.red);
      _tabController.animateTo(0);
      return false;
    }
    if (password?.isEmpty ?? true) {
      GlobalToast.show(
          context: context,
          message: 'كلمة المرور مطلوبة',
          backgroundColor: Colors.red);
      _tabController.animateTo(0);
      return false;
    }
    if (brandImg?.isEmpty ?? true) {
      GlobalToast.show(
          context: context,
          message: 'صورة المتجر مطلوبة',
          backgroundColor: Colors.red);
      _tabController.animateTo(0);
      return false;
    }
    if (selectedZones.isEmpty) {
      GlobalToast.show(
          context: context,
          message: 'يجب إضافة منطقة واحدة على الأقل',
          backgroundColor: Colors.red);
      _tabController.animateTo(1);
      return false;
    }

    return true;
  }

  Future<void> _submitRegistration() async {
    if (!_validateData()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final result = await ref.read(authNotifierProvider.notifier).register(
            fullName: fullName!,
            brandName: brandName!,
            userName: userName!,
            phoneNumber: phoneNumber!,
            password: password!,
            brandImg: brandImg!,
            zones: selectedZones,
            latitude: latitude,
            longitude: longitude,
            nearestLandmark: nearestLandmark,
          );

      if (result.$2 == "REGISTRATION_SUCCESS_PENDING_APPROVAL") {
        // ✅ تسجيل ناجح لكن يحتاج موافقة إدارية
        GlobalToast.show(
          context: context,
          message:
              "تم تسجيل حسابك بنجاح! سيتم مراجعة طلبك والموافقة عليه خلال 24 ساعة.",
          backgroundColor:
              const Color(0xFF16CA8B), // Primary color from light theme
          textColor: const Color(0xFFFFFFFF), // White text
        );

        await Future.delayed(const Duration(seconds: 3));

        if (mounted) {
          // الانتقال إلى شاشة انتظار التفعيل
          context.go(AppRoutes.pendingActivation);
        }
      } else if (result.$1 != null) {
        // ✅ حالة مثالية: تم التسجيل والحصول على بيانات المستخدم مباشرة
        await SharedPreferencesHelper.saveUser(result.$1!);

        GlobalToast.showSuccess(
          context: context,
          message: 'مرحباً بك في توصيل! تم تفعيل حسابك بنجاح',
          durationInSeconds: 3,
        );

        await Future.delayed(const Duration(seconds: 1));

        if (mounted) {
          context.go(AppRoutes.home);
        }
      } else {
        // ❌ خطأ حقيقي في التسجيل
        ('❌ فشل التسجيل: ${result.$2}');
        GlobalToast.show(
          context: context,
          message: result.$2 ?? 'فشل في التسجيل',
          backgroundColor:
              const Color(0xFFD54444), // Error color from light theme
          textColor: const Color(0xFFFFFFFF), // White text
          durationInSeconds: 4,
        );
      }
    } catch (e) {
      GlobalToast.show(
        context: context,
        message: 'خطأ في التسجيل: ${e.toString()}',
        backgroundColor:
            const Color(0xFFD54444), // Error color from light theme
        durationInSeconds: 4,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _clearAllData() {
    // حذف البيانات من UserInfoTab
    _userInfoTabKey.currentState?.clearAllFields();
    // حذف البيانات من DeliveryInfoTab
    _deliveryInfoTabKey.currentState?.clearAllFields();

    setState(() {
      fullName = null;
      brandName = null;
      userName = null;
      phoneNumber = null;
      password = null;
      brandImg = null;
      selectedZones.clear();
      latitude = null;
      longitude = null;
      nearestLandmark = null;
      _canNavigateToSecondTab = false;
      _currentIndex = 0;
    });
    _tabController.animateTo(0);
  }

  Future<bool> _onWillPop() async {
    if (fullName?.isNotEmpty == true ||
        brandName?.isNotEmpty == true ||
        userName?.isNotEmpty == true ||
        phoneNumber?.isNotEmpty == true ||
        brandImg?.isNotEmpty == true ||
        selectedZones.isNotEmpty) {
      final shouldExit = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text(
                'تأكيد الخروج',
                style: TextStyle(fontFamily: "Tajawal"),
              ),
              content: const Text(
                'سيتم فقدان جميع البيانات المدخلة. هل تريد الخروج؟',
                style: TextStyle(fontFamily: "Tajawal"),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('إلغاء',
                      style: TextStyle(fontFamily: "Tajawal")),
                ),
                TextButton(
                  onPressed: () {
                    _clearAllData();
                    Navigator.of(context).pop(true);
                  },
                  style: TextButton.styleFrom(
                      foregroundColor: const Color(
                          0xFFD54444)), // Error color from light theme
                  child: const Text('خروج',
                      style: TextStyle(fontFamily: "Tajawal")),
                ),
              ],
            ),
          ) ??
          false;
      return shouldExit;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final shouldPop = await _onWillPop();
          if (shouldPop && mounted) {
            context.pop();
          }
        }
      },
      child: Scaffold(
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              _buildBackgroundSection(),
              _buildBottomSheetSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundSection() {
    return Column(
      children: [
        Expanded(
          child: buildBackground(
            context: context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(25),
                CustomAppBar(
                  titleWidget: Text(
                    'تسجيل دخول',
                    style: context.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFFFFFFF), // White color
                        fontSize: 16),
                  ),
                  showBackButton: true,
                  onBackButtonPressed: () async {
                    final shouldPop = await _onWillPop();
                    if (shouldPop && mounted) {
                      context.push(AppRoutes.login);
                    }
                  },
                ),
                _buildLogo(),
                const Gap(10),
                _buildTitle(),
                _buildDescription(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: SvgPicture.asset("assets/svg/Logo.svg"),
    );
  }

  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        "انشاء حساب جديد",
        textAlign: TextAlign.right,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 32,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        "مرحبا بك في منصة توصيل، قم بادخال المعلومات ادناه و سيتم انشاء حساب لمتجرك بعد الموافقة و التفعيل.",
        textAlign: TextAlign.right,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildBottomSheetSection() {
    return DraggableScrollableSheet(
      initialChildSize: LoginDimensions.initialSheetSize,
      minChildSize: LoginDimensions.minSheetSize,
      maxChildSize: LoginDimensions.maxSheetSize,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFBFAFF), // Surface color from light theme
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildTabBar(),
              Expanded(
                child: _buildTabBarView(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: TabBar(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        indicator: const BoxDecoration(),
        labelPadding: EdgeInsets.zero,
        dividerColor: Colors.transparent,
        onTap: (index) {
          // السماح بالرجوع للتاب الأول فقط إذا كان التنقل للتاب الثاني مسموحاً
          if (index == 0 && _canNavigateToSecondTab) {
            _tabController.animateTo(0);
          }
          // منع التنقل للتاب الثاني عبر الضغط المباشر
          else if (index == 1 && !_canNavigateToSecondTab) {
            // لا تفعل شيئاً - منع التنقل
            return;
          }
        },
        tabs: List.generate(2, (i) {
          final bool isSelected = _currentIndex == i;
          final bool isCompleted = _currentIndex > i;
          final String label = i == 0 ? "معلومات الحساب" : "معلومات التوصيل";

          return Tab(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 8,
                  width: 160.w,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(
                            0xFF16CA8B) // Primary color from light theme
                        : isCompleted
                            ? const Color(
                                0xFF16CA8B) // Primary color from light theme
                            : const Color(
                                0xFFE7E0EC), // SurfaceVariant color from light theme
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const Gap(5),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected
                        ? const Color(
                            0xFF16CA8B) // Primary color from light theme
                        : isCompleted
                            ? const Color(
                                0xFF16CA8B) // Primary color from light theme
                            : const Color(
                                0xFF698596), // Secondary color from light theme
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        SingleChildScrollView(
          child: UserInfoTab(
            key: _userInfoTabKey,
            onNext: _goToNextTab,
            onUserInfoChanged: _updateUserInfo,
            initialData: {
              'fullName': fullName,
              'brandName': brandName,
              'userName': userName,
              'phoneNumber': phoneNumber,
              'password': password,
              'brandImg': brandImg,
            },
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              // ****************************************
              DeliveryInfoTab(
                key: _deliveryInfoTabKey,
                onZonesChangedWithLocation: _updateZonesWithLocation,
                initialZones: selectedZones,
              ),
              // ****************************************

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:
                      const Color(0xFFFBFAFF), // Surface color from light theme
                  border: Border(
                    top: BorderSide(
                        color: const Color(
                            0xFFEAEEF0)), // Outline color from light theme
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isSubmitting
                            ? null
                            : () => _tabController.animateTo(0),
                        child: const Text('السابق'),
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      flex: 2,
                      child: FilledButton(
                        onPressed: _isSubmitting ? null : _submitRegistration,
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('إنشاء الحساب'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
