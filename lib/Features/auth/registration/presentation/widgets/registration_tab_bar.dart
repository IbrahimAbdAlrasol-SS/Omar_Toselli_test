import 'package:flutter/material.dart';
import '../styles/registration_text_styles.dart';
import '../constants/registration_strings.dart';
import '../constants/registration_colors.dart';

class RegistrationTabBar extends StatelessWidget {
  final TabController tabController;
  final bool canNavigateToSecondTab;

  const RegistrationTabBar({
    super.key,
    required this.tabController,
    required this.canNavigateToSecondTab,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(RegistrationColors.whiteColor),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: TabBar(
        controller: tabController,
        labelStyle: RegistrationTextStyles.tabLabelStyle,
        unselectedLabelStyle: RegistrationTextStyles.tabLabelStyle,
        labelColor: const Color(RegistrationColors.primaryColor),
        unselectedLabelColor: const Color(RegistrationColors.greyColor),
        indicatorColor: const Color(RegistrationColors.primaryColor),
        tabs: const [
          Tab(text: RegistrationStrings.userInfoTab),
          Tab(text: RegistrationStrings.deliveryInfoTab),
        ],
        onTap: (index) {
          if (index == 1 && !canNavigateToSecondTab) {
            tabController.animateTo(0);
          }
        },
      ),
    );
  }
}