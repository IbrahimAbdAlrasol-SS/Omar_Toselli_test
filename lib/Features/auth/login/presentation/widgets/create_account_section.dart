import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:Tosell/core/config/constants/spaces.dart';
import 'package:Tosell/core/config/routes/app_router.dart';
import '../constants/login_strings.dart';
import '../styles/login_text_styles.dart';

class CreateAccountSection extends StatelessWidget {
  const CreateAccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          LoginStrings.noAccount,
          style: LoginTextStyles.noAccountText(context),
        ),
        const Gap(AppSpaces.exSmall),
        GestureDetector(
          onTap: () => context.go(AppRoutes.registerScreen),
          child: Text(
            LoginStrings.createNewAccount,
            style: LoginTextStyles.createAccountText(context),
          ),
        ),
      ],
    );
  }
}