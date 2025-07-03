import 'package:flutter/material.dart';
import '../screens/user_info_tab.dart';
import '../screens/delivery_info_tab.dart';
import '../state/registration_state_manager.dart';
import 'navigation_buttons.dart';

class RegistrationTabView extends StatelessWidget {
  final TabController tabController;
  final RegistrationStateManager stateManager;
  final GlobalKey userInfoTabKey;
  final GlobalKey deliveryInfoTabKey;
  final VoidCallback onNext;
  final Function({
    String? fullName,
    String? brandName,
    String? userName,
    String? phoneNumber,
    String? password,
    String? brandImg,
  }) onUserInfoChanged;
  final Function({
    required List zones,
    double? latitude,
    double? longitude,
    String? nearestLandmark,
  }) onZonesChanged;
  final VoidCallback onBack;
  final VoidCallback onSubmit;

  const RegistrationTabView({
    super.key,
    required this.tabController,
    required this.stateManager,
    required this.userInfoTabKey,
    required this.deliveryInfoTabKey,
    required this.onNext,
    required this.onUserInfoChanged,
    required this.onZonesChanged,
    required this.onBack,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildUserInfoTab(),
        _buildDeliveryInfoTab(),
      ],
    );
  }

  Widget _buildUserInfoTab() {
    return SingleChildScrollView(
      child: UserInfoTab(
        key: userInfoTabKey as GlobalKey<UserInfoTabState>,
        onNext: onNext,
        onUserInfoChanged: onUserInfoChanged,
        initialData: {
          'fullName': stateManager.fullName,
          'brandName': stateManager.brandName,
          'userName': stateManager.userName,
          'phoneNumber': stateManager.phoneNumber,
          'password': stateManager.password,
          'brandImg': stateManager.brandImg,
        },
      ),
    );
  }

  Widget _buildDeliveryInfoTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          DeliveryInfoTab(
            key: deliveryInfoTabKey as GlobalKey<DeliveryInfoTabState>,
            onZonesChangedWithLocation: onZonesChanged,
            initialZones: stateManager.selectedZones,
          ),
          const NavigationButtons(
            currentIndex: 0,
            isSubmitting: false,
            onBack: null,
            onNext: null,
            onSubmit: null,
          ),
        ],
      ),
    );
  }
}