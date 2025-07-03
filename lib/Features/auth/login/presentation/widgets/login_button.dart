import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Tosell/core/widgets/buttons/FillButton.dart';
import '../constants/login_strings.dart';
import '../controllers/login_controller.dart';

class LoginButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final AsyncValue<void> loginState;
  final WidgetRef ref;

  const LoginButton({
    super.key,
    required this.formKey,
    required this.phoneController,
    required this.passwordController,
    required this.loginState,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return FillButton(
      label: LoginStrings.login,
      isLoading: loginState.isLoading,
      onPressed: () => _handleLogin(context),
    );
  }

  Future<void> _handleLogin(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      await LoginController.handleLogin(
        context: context,
        ref: ref,
        phoneNumber: phoneController.text,
        password: passwordController.text,
        loginState: loginState,
      );
    }
  }
}