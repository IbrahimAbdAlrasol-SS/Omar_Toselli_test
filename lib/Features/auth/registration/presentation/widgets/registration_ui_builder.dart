import 'package:flutter/material.dart';
import 'package:Tosell/core/config/routes/app_router.dart';
import 'package:Tosell/core/utils/extensions/extensions.dart';
import 'package:Tosell/core/widgets/Others/CustomAppBar.dart';
import 'package:Tosell/features/auth/login/presentation/constants/login_dimensions.dart';
import 'package:Tosell/features/auth/registration/presentation/widgets/build_background.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../constants/registration_colors.dart';
import 'background_section.dart';
import 'registration_tab_bar.dart';
import '../screens/user_info_tab.dart';
import '../screens/delivery_info_tab.dart';
import 'navigation_buttons.dart';
import '../state/registration_state_manager.dart';

class RegistrationUIBuilder {
  static Widget buildMainScaffold({
    required BuildContext context,
    required Widget Function() buildBackgroundSection,
    required Widget Function() buildBottomSheetSection,
    required Future<bool> Function() onWillPop,
  }) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final shouldPop = await onWillPop();
          if (shouldPop && context.mounted) {
            context.pop();
          }
        }
      },
      child: Scaffold(
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              buildBackgroundSection(),
              buildBottomSheetSection(),
            ],
          ),
        ),
      ),
    );
  }
}