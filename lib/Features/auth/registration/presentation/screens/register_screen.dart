// lib/Features/auth/registration/presentation/screens/register_screen.dart
import 'package:Tosell/Features/auth/registration/presentation/constants/registration_assets.dart';
import 'package:Tosell/features/auth/registration/presentation/screens/delivery_info_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:Tosell/core/config/routes/app_router.dart';
import 'package:Tosell/core/utils/extensions/GlobalToast.dart';
import 'package:Tosell/features/profile/data/models/zone.dart';
import '../constants/registration_dimensions.dart';
import '../controllers/registration_controller.dart';
import '../controllers/tab_controller.dart';
import '../widgets/registration_header.dart';
import '../widgets/registration_tab_bar.dart';
import '../widgets/registration_bottom_sheet.dart';
import '../widgets/registration_background.dart';
import 'user_info_tab.dart';
import 'delivery_info_tab.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen>
    with SingleTickerProviderStateMixin {
  // Controllers
  late TabController _tabController;
  late RegistrationTabController _registrationTabController;
  
  // Keys
  final GlobalKey<UserInfoTabState> _userInfoTabKey = GlobalKey<UserInfoTabState>();
  final GlobalKey<DeliveryInfoTabState> _deliveryInfoTabKey = GlobalKey<DeliveryInfoTabState>();
  
  // State
  int _currentIndex = 0;
  bool _isSubmitting = false;
  
  // Form Data
  final Map<String, dynamic> _userData = {};
  List<Zone> _selectedZones = [];
  double? _latitude;
  double? _longitude;
  String? _nearestLandmark;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _tabController = TabController(length: 2, vsync: this);
    _registrationTabController = RegistrationTabController(
      tabController: _tabController,
      onTabChanged: (index) {
        setState(() => _currentIndex = index);
      },
    );
  }

  @override
  void dispose() {
    _registrationTabController.dispose();
    super.dispose();
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
              _buildBackground(),
              _buildBottomSheet(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Column(
      children: [
        RegistrationBackground(
          child: RegistrationHeader(
            onBackPressed: () async {
              final shouldPop = await _onWillPop();
              if (shouldPop && mounted) {
                context.push(AppRoutes.login);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSheet() {
    return DraggableScrollableSheet(
      initialChildSize: RegistrationDimensions.initialSheetSize,
      minChildSize: RegistrationDimensions.minSheetSize,
      maxChildSize: RegistrationDimensions.maxSheetSize,
      builder: (context, scrollController) {
        return RegistrationBottomSheet(
          scrollController: scrollController,
          child: Column(
            children: [
              RegistrationTabBar(
                tabController: _tabController,
                currentIndex: _currentIndex,
                onTap: _registrationTabController.goToTab,
                canNavigateToSecondTab: _registrationTabController.canNavigateToSecondTab,
              ),
              Expanded(
                child: _buildTabBarView(),
              ),
            ],
          ),
        );
      },
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
            onNext: _handleNextTab,
            onUserInfoChanged: _updateUserInfo,
            initialData: _userData,
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              DeliveryInfoTab(
                key: _deliveryInfoTabKey,
                onZonesChangedWithLocation: _updateZonesWithLocation,
                initialZones: _selectedZones,
              ),
              _buildSubmitButtons(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFAFF),
        border: Border(
          top: BorderSide(color: const Color(0xFFEAEEF0)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _isSubmitting 
                  ? null 
                  : () => _registrationTabController.goToPreviousTab(),
              child: const Text('السابق'),
            ),
          ),
          const SizedBox(width: 16),
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
    );
  }

  void _handleNextTab() {
    _registrationTabController.goToNextTab();
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
      if (fullName != null) _userData['fullName'] = fullName;
      if (brandName != null) _userData['brandName'] = brandName;
      if (userName != null) _userData['userName'] = userName;
      if (phoneNumber != null) _userData['phoneNumber'] = phoneNumber;
      if (password != null) _userData['password'] = password;
      if (brandImg != null) _userData['brandImg'] = brandImg;
    });
  }

  void _updateZonesWithLocation({
    required List<Zone> zones,
    double? latitude,
    double? longitude,
    String? nearestLandmark,
  }) {
    setState(() {
      _selectedZones = zones;
      _latitude = latitude;
      _longitude = longitude;
      _nearestLandmark = nearestLandmark;
    });
  }

  Future<void> _submitRegistration() async {
    if (!_validateData()) return;

    setState(() => _isSubmitting = true);

    try {
      await RegistrationController.handleRegistration(
        context: context,
        ref: ref,
        fullName: _userData['fullName']!,
        brandName: _userData['brandName']!,
        userName: _userData['userName']!,
        phoneNumber: _userData['phoneNumber']!,
        password: _userData['password']!,
        brandImg: _userData['brandImg']!,
        zones: _selectedZones,
        latitude: _latitude,
        longitude: _longitude,
        nearestLandmark: _nearestLandmark,
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  bool _validateData() {
    // Validate user info
    final userInfoErrors = <String>[];
    
    if (_userData['fullName']?.isEmpty ?? true) {
      userInfoErrors.add('اسم صاحب المتجر مطلوب');
    }
    if (_userData['brandName']?.isEmpty ?? true) {
      userInfoErrors.add('اسم المتجر مطلوب');
    }
    if (_userData['userName']?.isEmpty ?? true) {
      userInfoErrors.add('اسم المستخدم مطلوب');
    }
    if (_userData['phoneNumber']?.isEmpty ?? true) {
      userInfoErrors.add('رقم الهاتف مطلوب');
    }
    if (_userData['password']?.isEmpty ?? true) {
      userInfoErrors.add('كلمة المرور مطلوبة');
    }
    if (_userData['brandImg']?.isEmpty ?? true) {
      userInfoErrors.add('صورة المتجر مطلوبة');
    }

    if (userInfoErrors.isNotEmpty) {
      GlobalToast.show(
        context: context,
        message: userInfoErrors.first,
        backgroundColor: const Color(0xFFD54444),
      );
      _tabController.animateTo(0);
      return false;
    }

    // Validate delivery info
    if (_selectedZones.isEmpty) {
      GlobalToast.show(
        context: context,
        message: 'يجب إضافة منطقة واحدة على الأقل',
        backgroundColor: const Color(0xFFD54444),
      );
      _tabController.animateTo(1);
      return false;
    }

    return true;
  }

  Future<bool> _onWillPop() async {
    if (_hasData()) {
      final shouldExit = await _showExitConfirmation();
      if (shouldExit == true) {
        _clearAllData();
      }
      return shouldExit ?? false;
    }
    return true;
  }

  bool _hasData() {
    return _userData.isNotEmpty || _selectedZones.isNotEmpty;
  }

  Future<bool?> _showExitConfirmation() {
    return showDialog<bool>(
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
            child: const Text('إلغاء', style: TextStyle(fontFamily: "Tajawal")),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: const Color(0xFFD54444)),
            child: const Text('خروج', style: TextStyle(fontFamily: "Tajawal")),
          ),
        ],
      ),
    );
  }

  void _clearAllData() {
    _userInfoTabKey.currentState?.clearAllFields();
    _deliveryInfoTabKey.currentState?.clearAllFields();
    setState(() {
      _userData.clear();
      _selectedZones.clear();
      _latitude = null;
      _longitude = null;
      _nearestLandmark = null;
    });
    _registrationTabController.resetToFirstTab();
  }
}