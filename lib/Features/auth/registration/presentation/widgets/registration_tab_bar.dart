
// lib/Features/auth/registration/presentation/widgets/registration_tab_bar.dart
import 'package:Tosell/Features/auth/registration/presentation/constants/registration_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../constants/registration_strings.dart';
import '../styles/registration_text_styles.dart';

class RegistrationTabBar extends StatelessWidget {
  final TabController tabController;
  final int currentIndex;
  final Function(int) onTap;
  final bool canNavigateToSecondTab;

  const RegistrationTabBar({
    super.key,
    required this.tabController,
    required this.currentIndex,
    required this.onTap,
    required this.canNavigateToSecondTab,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: TabBar(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        indicator: const BoxDecoration(),
        labelPadding: EdgeInsets.zero,
        dividerColor: Colors.transparent,
        onTap: (index) {
          if (index == 0 && canNavigateToSecondTab) {
            onTap(0);
          } else if (index == 1 && !canNavigateToSecondTab) {
            return;
          }
        },
        tabs: List.generate(2, (index) => _buildTab(context, index)),
      ),
    );
  }

  Widget _buildTab(BuildContext context, int index) {
    final bool isSelected = currentIndex == index;
    final bool isCompleted = currentIndex > index;
    final String label = index == 0 
        ? RegistrationStrings.userInfoTab 
        : RegistrationStrings.deliveryInfoTab;

    return Tab(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTabIndicator(isSelected, isCompleted),
          const Gap(5),
          Text(
            label,
            style: RegistrationTextStyles.tabTitle(
              context, 
              isSelected: isSelected || isCompleted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabIndicator(bool isSelected, bool isCompleted) {
    return Container(
      height: 8,
      width: 160.w,
      decoration: BoxDecoration(
        color: (isSelected || isCompleted)
            ? const Color(0xFF16CA8B)
            : const Color(0xFFE7E0EC),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
