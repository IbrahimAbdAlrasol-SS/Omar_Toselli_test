import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../styles/registration_text_styles.dart';
import '../constants/registration_colors.dart';

class BackgroundSection extends StatelessWidget {
  const BackgroundSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(RegistrationColors.primaryColor),
            Color(RegistrationColors.primaryLightColor),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLogo(),
          const SizedBox(height: 20),
          _buildTitle(),
          const SizedBox(height: 10),
          _buildDescription(),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return SvgPicture.asset(
      'assets/images/logo.svg',
      height: 120,
      width: 120,
    );
  }

  Widget _buildTitle() {
    return const Text(
      'إنشاء حساب جديد',
      style: RegistrationTextStyles.titleStyle,
    );
  }

  Widget _buildDescription() {
    return const Text(
      'انضم إلى منصة توصيل وابدأ رحلتك في التجارة الإلكترونية',
      style: RegistrationTextStyles.descriptionStyle,
      textAlign: TextAlign.center,
    );
  }
}