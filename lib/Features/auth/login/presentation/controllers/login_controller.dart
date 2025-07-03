import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:Tosell/core/config/routes/app_router.dart';
import 'package:Tosell/core/utils/extensions/GlobalToast.dart';
import 'package:Tosell/core/utils/extensions/extensions.dart';
import 'package:Tosell/core/utils/helpers/SharedPreferencesHelper.dart';
import 'package:Tosell/features/auth/login/data/provider/auth_provider.dart';
import '../constants/login_strings.dart';

class LoginController {
  static Future<void> handleLogin({
    required BuildContext context,
    required WidgetRef ref,
    required String phoneNumber,
    required String password,
    required AsyncValue<void> loginState,
  }) async {
    final result = await ref
        .read(authNotifierProvider.notifier)
        .login(passWord: password, phonNumber: phoneNumber);

    if (result.$1 == null) {
      _showErrorToast(context, result.$2!);
    } else {
      await _handleSuccessfulLogin(context, result, loginState);
    }
  }

  static void _showErrorToast(BuildContext context, String message) {
    GlobalToast.show(
      context: context,
      message: message,
      backgroundColor: const Color(0xFFD54444), // Error color from light theme
      textColor: const Color(0xFFFFFFFF), // White text
    );
  }

  static Future<void> _handleSuccessfulLogin(
    BuildContext context,
    (dynamic, String?) result,
    AsyncValue<void> loginState,
  ) async {
    if (result.$2 == "ACCOUNT_PENDING_ACTIVATION") {
      _showPendingActivationToast(context);
      context.go(LoginStrings.pendingActivationRoute);
    } else {
      _showSuccessToast(context);
      if (loginState is AsyncData) {
        await SharedPreferencesHelper.saveUser(result.$1!);
        context.go(AppRoutes.home);
      }
    }
  }

  static void _showPendingActivationToast(BuildContext context) {
    GlobalToast.show(
      context: context,
      message: LoginStrings.accountPendingActivation,
      backgroundColor:
          const Color(0xFF16CA8B), // Primary color from light theme
      textColor: const Color(0xFFFFFFFF), // White text
    );
  }

  static void _showSuccessToast(BuildContext context) {
    GlobalToast.show(
      context: context,
      message: LoginStrings.loginSuccess,
      backgroundColor:
          const Color(0xFF16CA8B), // Primary color from light theme
      textColor: const Color(0xFFFFFFFF), // White text
    );
  }
}
