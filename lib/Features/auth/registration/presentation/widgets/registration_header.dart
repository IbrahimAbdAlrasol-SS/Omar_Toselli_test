// lib/Features/auth/registration/presentation/widgets/registration_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:Tosell/core/widgets/Others/CustomAppBar.dart';
import '../constants/registration_assets.dart';
import '../constants/registration_dimensions.dart';
import '../constants/registration_strings.dart';
import '../styles/registration_text_styles.dart';

class RegistrationHeader extends StatelessWidget {
  final VoidCallback onBackPressed;

  const RegistrationHeader({
    super.key,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(RegistrationDimensions.topGap),
        CustomAppBar(
          titleWidget: Text(
            RegistrationStrings.appBarTitle,
            style: RegistrationTextStyles.appBarTitle(context),
          ),
          showBackButton: true,
          onBackButtonPressed: onBackPressed,
        ),
        _buildLogo(),
        const Gap(RegistrationDimensions.logoGap),
        _buildTitle(context),
        const Gap(RegistrationDimensions.titleGap),
        _buildDescription(context),
      ],
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.only(right: RegistrationDimensions.horizontalPadding),
      child: SvgPicture.asset(RegistrationAssets.logo),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: RegistrationDimensions.horizontalPadding),
      child: Text(
        RegistrationStrings.createNewAccount,
        textAlign: TextAlign.right,
        style: RegistrationTextStyles.welcomeTitle(context),
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: RegistrationDimensions.horizontalPadding),
      child: Text(
        RegistrationStrings.welcomeDescription,
        textAlign: TextAlign.right,
        style: RegistrationTextStyles.welcomeSubtitle(context),
      ),
    );
  }
}

