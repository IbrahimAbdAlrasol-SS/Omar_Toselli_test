// lib/Features/auth/registration/presentation/controllers/registration_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:Tosell/core/config/routes/app_router.dart';
import 'package:Tosell/core/utils/extensions/GlobalToast.dart';
import 'package:Tosell/features/auth/login/data/provider/auth_provider.dart';
import 'package:Tosell/features/profile/data/models/zone.dart';
import 'package:Tosell/features/auth/pending_activation/presentation/providers/activation_timer_provider.dart';

class RegistrationController {
  static Future<void> handleRegistration({
    required BuildContext context,
    required WidgetRef ref,
    required String fullName,
    required String brandName,
    required String userName,
    required String phoneNumber,
    required String password,
    required String brandImg,
    required List<Zone> zones,
    double? latitude,
    double? longitude,
    String? nearestLandmark,
  }) async {
    try {
      final result = await ref.read(authNotifierProvider.notifier).register(
        fullName: fullName,
        brandName: brandName,
        userName: userName,
        phoneNumber: phoneNumber,
        password: password,
        brandImg: brandImg,
        zones: zones,
        latitude: latitude,
        longitude: longitude,
        nearestLandmark: nearestLandmark,
      );

      if (result.$2 == "REGISTRATION_SUCCESS_PENDING_APPROVAL") {
        // ✅ بدء المؤقت
        await ref.read(activationTimerProvider.notifier).startNewTimer();
        _showPendingApprovalToast(context);
        await Future.delayed(const Duration(seconds: 3));
        if (context.mounted) {
          context.go(AppRoutes.pendingActivation);
        }
      } else if (result.$1 != null) {
        _showSuccessToast(context);
        await Future.delayed(const Duration(seconds: 1));
        if (context.mounted) {
          context.go(AppRoutes.home);
        }
      } else {
        _showErrorToast(context, result.$2 ?? 'فشل في التسجيل');
      }
    } catch (e) {
      _showErrorToast(context, 'خطأ في التسجيل: ${e.toString()}');
    }
  }

  static void _showPendingApprovalToast(BuildContext context) {
    GlobalToast.show(
      context: context,
      message: "تم تسجيل حسابك بنجاح! سيتم مراجعة طلبك والموافقة عليه خلال 24 ساعة.",
      backgroundColor: const Color(0xFF16CA8B),
      textColor: const Color(0xFFFFFFFF),
    );
  }

  static void _showSuccessToast(BuildContext context) {
    GlobalToast.showSuccess(
      context: context,
      message: 'مرحباً بك في توصيل! تم تفعيل حسابك بنجاح',
      durationInSeconds: 3,
    );
  }

  static void _showErrorToast(BuildContext context, String message) {
    GlobalToast.show(
      context: context,
      message: message,
      backgroundColor: const Color(0xFFD54444),
      textColor: const Color(0xFFFFFFFF),
      durationInSeconds: 4,
    );
  }
}