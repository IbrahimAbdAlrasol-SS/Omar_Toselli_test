import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:Tosell/core/config/routes/app_router.dart';
import 'package:Tosell/core/widgets/Others/CustomAppBar.dart';
import '../constants/login_strings.dart';
import '../styles/login_text_styles.dart';

class LoginAppBar extends StatelessWidget {
  const LoginAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      titleWidget: Text(
        LoginStrings.createAccount,
        style: LoginTextStyles.appBarTitle(context),
      ),
      showBackButton: true,
      onBackButtonPressed: () => context.push(AppRoutes.registerScreen),
    );
  }
}