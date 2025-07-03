import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:Tosell/core/config/routes/app_router.dart';
import 'package:Tosell/core/utils/extensions/GlobalToast.dart';
import 'package:Tosell/core/utils/helpers/SharedPreferencesHelper.dart';
import 'package:Tosell/features/auth/login/data/provider/auth_provider.dart';
import 'package:Tosell/features/profile/data/models/zone.dart';
import '../constants/registration_colors.dart';

class RegistrationService {
  static Future<void> submitRegistration({
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
      
      await _handleRegistrationResult(context, result);
    } catch (e) {
      _showError(context, 'خطأ في التسجيل: ${e.toString()}');
    }
  }
  
  static Future<void> _handleRegistrationResult(
    BuildContext context, 
    dynamic result
  ) async {
    if (result.$2 == "REGISTRATION_SUCCESS_PENDING_APPROVAL") {
      _showPendingApproval(context);
      await Future.delayed(const Duration(seconds: 3));
      if (context.mounted) {
        context.go(AppRoutes.pendingActivation);
      }
    } else if (result.$1 != null) {
      await _handleSuccessfulRegistration(context, result.$1);
    } else {
      _showError(context, result.$2 ?? 'فشل في التسجيل');
    }
  }
  
  static void _showPendingApproval(BuildContext context) {
    GlobalToast.show(
      context: context,
      message: "تم تسجيل حسابك بنجاح! سيتم مراجعة طلبك والموافقة عليه خلال 24 ساعة.",
      backgroundColor: const Color(RegistrationColors.primaryColor),
      textColor: const Color(RegistrationColors.whiteColor),
    );
  }
  
  static Future<void> _handleSuccessfulRegistration(
    BuildContext context, 
    dynamic user
  ) async {
    await SharedPreferencesHelper.saveUser(user);
    GlobalToast.showSuccess(
      context: context,
      message: 'مرحباً بك في توصيل! تم تفعيل حسابك بنجاح',
      durationInSeconds: 3,
    );
    await Future.delayed(const Duration(seconds: 1));
    if (context.mounted) {
      context.go(AppRoutes.home);
    }
  }
  
  static void _showError(BuildContext context, String message) {
    GlobalToast.show(
      context: context,
      message: message,
      backgroundColor: const Color(RegistrationColors.errorColor),
      textColor: const Color(RegistrationColors.whiteColor),
      durationInSeconds: 4,
    );
  }
}