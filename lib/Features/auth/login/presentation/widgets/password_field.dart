import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Tosell/core/widgets/inputs/CustomTextFormField.dart';
import '../constants/login_assets.dart';
import '../constants/login_dimensions.dart';
import '../constants/login_strings.dart';
import '../validators/login_validators.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isPasswordVisible;
  final VoidCallback onVisibilityToggle;

  const PasswordField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isPasswordVisible,
    required this.onVisibilityToggle,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: controller,
      obscureText: !isPasswordVisible,
      focusNode: focusNode,
      label: LoginStrings.password,
      validator: LoginValidators.validatePassword,
      prefixInner: Padding(
        padding: const EdgeInsets.all(LoginDimensions.iconPadding),
        child: SvgPicture.asset(
          LoginAssets.passwordIcon,
          color: const Color(0xFF16CA8B), // Primary color from light theme
        ),
      ),
      suffixInner: IconButton(
        onPressed: onVisibilityToggle,
        icon: SvgPicture.asset(
          isPasswordVisible ? LoginAssets.eyeIcon : LoginAssets.eyeSlashIcon,
          color: const Color(0xFF16CA8B), // Primary color from light theme
        ),
      ),
    );
  }
}
