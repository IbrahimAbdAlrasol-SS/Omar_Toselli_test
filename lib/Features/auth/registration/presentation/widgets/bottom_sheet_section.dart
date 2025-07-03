import 'package:flutter/material.dart';
import 'package:Tosell/features/auth/login/presentation/constants/login_dimensions.dart';
import '../constants/registration_colors.dart';
import 'registration_tab_bar.dart';
import 'registration_tab_view.dart';
import '../state/registration_state_manager.dart';

class BottomSheetSection extends StatelessWidget {
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

  const BottomSheetSection({
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
    return DraggableScrollableSheet(
      initialChildSize: LoginDimensions.initialSheetSize,
      minChildSize: LoginDimensions.minSheetSize,
      maxChildSize: LoginDimensions.maxSheetSize,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(RegistrationColors.surfaceColor),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              RegistrationTabBar(
                tabController: tabController,
                canNavigateToSecondTab: stateManager.canNavigateToSecondTab,
              ),
              Expanded(
                child: RegistrationTabView(
                  tabController: tabController,
                  stateManager: stateManager,
                  userInfoTabKey: userInfoTabKey,
                  deliveryInfoTabKey: deliveryInfoTabKey,
                  onNext: onNext,
                  onUserInfoChanged: onUserInfoChanged,
                  onZonesChanged: onZonesChanged,
                  onBack: onBack,
                  onSubmit: onSubmit,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}