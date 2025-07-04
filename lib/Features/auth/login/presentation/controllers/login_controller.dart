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
    try {
      final result = await ref
          .read(authNotifierProvider.notifier)
          .login(passWord: password, phonNumber: phoneNumber);

      print('🔍 Login Result: User=${result.$1?.userName}, Error=${result.$2}');

      // التحقق من السياق قبل عرض Toast
      if (!context.mounted) return;

      if (result.$1 == null && result.$2 != "ACCOUNT_PENDING_ACTIVATION") {
        _showErrorToast(context, result.$2 ?? 'فشل في تسجيل الدخول');
        return;
      }

      await _handleSuccessfulLogin(context, result, loginState);
    } catch (e) {
      print('❌ Login Exception: $e');
      if (context.mounted) {
        _showErrorToast(context, 'خطأ في تسجيل الدخول: ${e.toString()}');
      }
    }
  }

  static void _showErrorToast(BuildContext context, String message) {
    if (!context.mounted) return;
    
    GlobalToast.show(
      context: context,
      message: message,
      backgroundColor: const Color(0xFFD54444),
      textColor: const Color(0xFFFFFFFF),
    );
  }

  static Future<void> _handleSuccessfulLogin(
    BuildContext context,
    (dynamic, String?) result,
    AsyncValue<void> loginState,
  ) async {
    if (!context.mounted) return;
    
    if (result.$2 == "ACCOUNT_PENDING_ACTIVATION") {
      _showPendingActivationToast(context);
      await Future.delayed(const Duration(seconds: 1));
      
      if (context.mounted) {
        context.go(AppRoutes.pendingActivation);
      }
    } else if (result.$1 != null) {
      _showSuccessToast(context);
      
      await SharedPreferencesHelper.saveUser(result.$1!);
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (context.mounted) {
        context.go(AppRoutes.home);
      }
    }
  }

  static void _showPendingActivationToast(BuildContext context) {
    if (!context.mounted) return;
    
    GlobalToast.show(
      context: context,
      message: LoginStrings.accountPendingActivation,
      backgroundColor: const Color(0xFF16CA8B),
      textColor: const Color(0xFFFFFFFF),
    );
  }

  static void _showSuccessToast(BuildContext context) {
    if (!context.mounted) return;
    
    GlobalToast.show(
      context: context,
      message: LoginStrings.loginSuccess,
      backgroundColor: const Color(0xFF16CA8B),
      textColor: const Color(0xFFFFFFFF),
    );
  }
}