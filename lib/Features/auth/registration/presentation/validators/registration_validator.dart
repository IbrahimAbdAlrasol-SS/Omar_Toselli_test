import 'package:Tosell/core/utils/extensions/GlobalToast.dart';
import 'package:flutter/material.dart';
import '../constants/registration_strings.dart';
import '../constants/registration_colors.dart';

class RegistrationValidator {
  static bool validateUserData({
    required BuildContext context,
    required String? fullName,
    required String? brandName,
    required String? userName,
    required String? phoneNumber,
    required String? password,
    required String? brandImg,
    required Function(int) navigateToTab,
  }) {
    if (fullName?.isEmpty ?? true) {
      _showError(context, RegistrationStrings.fullNameRequired);
      navigateToTab(0);
      return false;
    }
    if (brandName?.isEmpty ?? true) {
      _showError(context, RegistrationStrings.brandNameRequired);
      navigateToTab(0);
      return false;
    }
    return true;
  }
  
  static void _showError(BuildContext context, String message) {
    GlobalToast.show(
      context: context,
      message: message,
      backgroundColor: const Color(RegistrationColors.errorColor),
    );
  }
}