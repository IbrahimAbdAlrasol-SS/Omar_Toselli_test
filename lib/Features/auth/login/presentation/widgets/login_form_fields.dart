import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:Tosell/core/config/constants/spaces.dart';
import 'phone_field.dart';
import 'password_field.dart';

class LoginFormFields extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final FocusNode phoneFocusNode;
  final FocusNode passwordFocusNode;
  final bool isPasswordVisible;
  final VoidCallback onPasswordVisibilityToggle;

  const LoginFormFields({
    super.key,
    required this.phoneController,
    required this.passwordController,
    required this.phoneFocusNode,
    required this.passwordFocusNode,
    required this.isPasswordVisible,
    required this.onPasswordVisibilityToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PhoneField(
          controller: phoneController,
          focusNode: phoneFocusNode,
        ),
        const Gap(AppSpaces.medium),
        PasswordField(
          controller: passwordController,
          focusNode: passwordFocusNode,
          isPasswordVisible: isPasswordVisible,
          onVisibilityToggle: onPasswordVisibilityToggle,
        ),
      ],
    );
  }
}