import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../constants/login_dimensions.dart';
import '../constants/login_strings.dart';
import '../styles/login_text_styles.dart';
class WelcomeTexts extends StatelessWidget {
  const WelcomeTexts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: LoginDimensions.horizontalPadding,
          ),
          child: Text(
            LoginStrings.welcomeBack,
            textAlign: TextAlign.right,
            style: LoginTextStyles.welcomeTitle(context),
          ),
        ),
        const Gap(LoginDimensions.titleGap),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: LoginDimensions.horizontalPadding,
          ),
          child: Text(
            LoginStrings.welcomeDescription,
            textAlign: TextAlign.right,
            style: LoginTextStyles.welcomeSubtitle(context),
          ),
        ),
      ],
    );
  }
}