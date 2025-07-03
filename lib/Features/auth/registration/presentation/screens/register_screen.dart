import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Tosell/features/profile/data/models/zone.dart';
import '../state/registration_state_manager.dart';
import '../services/registration_service.dart';
import '../validators/registration_validator.dart';
import '../widgets/exit_confirmation_dialog.dart';
import '../widgets/background_with_appbar.dart';
import '../widgets/bottom_sheet_section.dart';
import '../widgets/registration_ui_builder.dart';
import 'user_info_tab.dart';
import 'delivery_info_tab.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<UserInfoTabState> _userInfoTabKey = GlobalKey<UserInfoTabState>();
  final GlobalKey<DeliveryInfoTabState> _deliveryInfoTabKey = GlobalKey<DeliveryInfoTabState>();
  final RegistrationStateManager _stateManager = RegistrationStateManager();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _goToNextTab() {
    if (_stateManager.currentIndex < _tabController.length - 1) {
      setState(() {
        _stateManager.canNavigateToSecondTab = true;
      });
      _tabController.animateTo(_stateManager.currentIndex + 1);
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
      _stateManager.updateUserInfo(
        fullName: fullName,
        brandName: brandName,
        userName: userName,
        phoneNumber: phoneNumber,
        password: password,
        brandImg: brandImg,
      );
    });
  }

  bool _validateData() {
    return RegistrationValidator.validateUserData(
      context: context,
      fullName: _stateManager.fullName,
      brandName: _stateManager.brandName,
      userName: _stateManager.userName,
      phoneNumber: _stateManager.phoneNumber,
      password: _stateManager.password,
      brandImg: _stateManager.brandImg,
      navigateToTab: (index) => _tabController.animateTo(index),
    );
  }

  Future<void> _submitRegistration() async {
    if (!_validateData()) return;

    setState(() {
      _stateManager.isSubmitting = true;
    });

    await RegistrationService.submitRegistration(
      context: context,
      ref: ref,
      fullName: _stateManager.fullName!,
      brandName: _stateManager.brandName!,
      userName: _stateManager.userName!,
      phoneNumber: _stateManager.phoneNumber!,
      password: _stateManager.password!,
      brandImg: _stateManager.brandImg!,
      zones: _stateManager.selectedZones,
      latitude: _stateManager.latitude,
      longitude: _stateManager.longitude,
      nearestLandmark: _stateManager.nearestLandmark,
    );

    if (mounted) {
      setState(() {
        _stateManager.isSubmitting = false;
      });
    }
  }

  void _clearAllData() {
    _userInfoTabKey.currentState?.clearAllFields();
    _deliveryInfoTabKey.currentState?.clearAllFields();
    setState(() {
      _stateManager.fullName = null;
      _stateManager.brandName = null;
      _stateManager.userName = null;
      _stateManager.phoneNumber = null;
      _stateManager.password = null;
      _stateManager.brandImg = null;
      _stateManager.selectedZones.clear();
      _stateManager.latitude = null;
      _stateManager.longitude = null;
      _stateManager.nearestLandmark = null;
      _stateManager.canNavigateToSecondTab = false;
      _stateManager.currentIndex = 0;
    });
    _tabController.animateTo(0);
  }

  Future<bool> _onWillPop() async {
    if (_stateManager.fullName?.isNotEmpty == true ||
        _stateManager.brandName?.isNotEmpty == true ||
        _stateManager.userName?.isNotEmpty == true ||
        _stateManager.phoneNumber?.isNotEmpty == true ||
        _stateManager.brandImg?.isNotEmpty == true ||
        _stateManager.selectedZones.isNotEmpty) {
      return await ExitConfirmationDialog.show(
        context: context,
        onConfirmExit: _clearAllData,
      );
    }
    return true;
  }

  void _updateZonesWithLocation({
    required List zones,
    double? latitude,
    double? longitude,
    String? nearestLandmark,
  }) {
    setState(() {
      _stateManager.selectedZones = zones.cast<Zone>();
      _stateManager.latitude = latitude;
      _stateManager.longitude = longitude;
      _stateManager.nearestLandmark = nearestLandmark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RegistrationUIBuilder.buildMainScaffold(
      context: context,
      buildBackgroundSection: () => BackgroundWithAppBar(
        onWillPop: _onWillPop,
      ),
      buildBottomSheetSection: () => BottomSheetSection(
        tabController: _tabController,
        stateManager: _stateManager,
        userInfoTabKey: _userInfoTabKey,
        deliveryInfoTabKey: _deliveryInfoTabKey,
        onNext: _goToNextTab,
        onUserInfoChanged: _updateUserInfo,
        onZonesChanged: _updateZonesWithLocation,
        onBack: () => _tabController.animateTo(0),
        onSubmit: _submitRegistration,
      ),
      onWillPop: _onWillPop,
    );
  }
}

  
