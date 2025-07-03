import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'create_account_section.dart';
import 'login_form_fields.dart';
import 'login_shape_widget.dart';
import 'login_button.dart';
import 'login_spacing.dart';

class SheetContent extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final FocusNode phoneFocusNode;
  final FocusNode passwordFocusNode;
  final bool isPasswordVisible;
  final VoidCallback onPasswordVisibilityToggle;
  final bool isTextFieldFocused;
  final AsyncValue<void> loginState;
  final WidgetRef ref;

  const SheetContent({
    super.key,
    required this.formKey,
    required this.phoneController,
    required this.passwordController,
    required this.phoneFocusNode,
    required this.passwordFocusNode,
    required this.isPasswordVisible,
    required this.onPasswordVisibilityToggle,
    required this.isTextFieldFocused,
    required this.loginState,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LoginSpacing.topGap(),
        LoginShapeWidget(isVisible: !isTextFieldFocused),
        Form(
          key: formKey,
          child: LoginFormFields(
            phoneController: phoneController,
            passwordController: passwordController,
            phoneFocusNode: phoneFocusNode,
            passwordFocusNode: passwordFocusNode,
            isPasswordVisible: isPasswordVisible,
            onPasswordVisibilityToggle: onPasswordVisibilityToggle,
          ),
        ),
        LoginSpacing.formGap(),
        const CreateAccountSection(),
        LoginSpacing.buttonTopGap(isTextFieldFocused),
        LoginButton(
          formKey: formKey,
          phoneController: phoneController,
          passwordController: passwordController,
          loginState: loginState,
          ref: ref,
        ),
        LoginSpacing.buttonBottomGap(isTextFieldFocused),
      ],
    );
  }
}