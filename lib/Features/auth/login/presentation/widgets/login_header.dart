import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:Tosell/features/auth/registration/presentation/widgets/build_background.dart';
import '../constants/login_dimensions.dart';
import 'login_app_bar.dart';
import 'logo_widget.dart';
import 'welcome_texts.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: buildBackground(
        context: context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(LoginDimensions.topGap),
            const LoginAppBar(),
            const Padding(
              padding: EdgeInsets.only(right: LoginDimensions.horizontalPadding),
              child: LogoWidget(),
            ),
            const Gap(LoginDimensions.logoGap),
            const WelcomeTexts(),
          ],
        ),
      ),
    );
  }
}