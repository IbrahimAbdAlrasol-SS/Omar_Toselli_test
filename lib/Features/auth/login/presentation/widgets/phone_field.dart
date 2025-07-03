import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Tosell/core/widgets/inputs/CustomTextFormField.dart';
import '../constants/login_assets.dart';
import '../constants/login_dimensions.dart';
import '../constants/login_strings.dart';
import '../validators/login_validators.dart';

class PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const PhoneField({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: controller,
      label: LoginStrings.phoneNumber,
      focusNode: focusNode,
      validator: LoginValidators.validatePhone,
      prefixInner: Padding(
        padding: const EdgeInsets.all(LoginDimensions.iconPadding),
        child: SvgPicture.asset(
          LoginAssets.phoneIcon,
          color: const Color(0xFF16CA8B), // Primary color from light theme
        ),
      ),
    );
  }
}
