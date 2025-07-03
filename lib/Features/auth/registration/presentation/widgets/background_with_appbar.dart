import 'package:flutter/material.dart';
import 'package:Tosell/core/config/routes/app_router.dart';
import 'package:Tosell/core/utils/extensions/extensions.dart';
import 'package:Tosell/core/widgets/Others/CustomAppBar.dart';
import 'package:Tosell/features/auth/registration/presentation/widgets/build_background.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../constants/registration_colors.dart';
import 'background_section.dart';

class BackgroundWithAppBar extends StatelessWidget {
  final Future<bool> Function() onWillPop;

  const BackgroundWithAppBar({
    super.key,
    required this.onWillPop,
  });

  @override
  Widget build(BuildContext context) {
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
                      color: const Color(RegistrationColors.whiteColor),
                      fontSize: 16,
                    ),
                  ),
                  showBackButton: true,
                  onBackButtonPressed: () async {
                    final shouldPop = await onWillPop();
                    if (shouldPop && context.mounted) {
                      context.push(AppRoutes.login);
                    }
                  },
                ),
                const Expanded(
                  child: BackgroundSection(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}