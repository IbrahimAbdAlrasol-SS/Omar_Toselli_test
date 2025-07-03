import 'package:flutter/material.dart';
import '../styles/registration_text_styles.dart';
import '../constants/registration_colors.dart';

class ExitConfirmationDialog {
  static Future<bool> show({
    required BuildContext context,
    required VoidCallback onConfirmExit,
  }) async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'تأكيد الخروج',
          style: RegistrationTextStyles.dialogTitleStyle,
        ),
        content: const Text(
          'سيتم فقدان جميع البيانات المدخلة. هل تريد الخروج؟',
          style: RegistrationTextStyles.dialogTitleStyle,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'إلغاء',
              style: RegistrationTextStyles.dialogTitleStyle,
            ),
          ),
          TextButton(
            onPressed: () {
              onConfirmExit();
              Navigator.of(context).pop(true);
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(RegistrationColors.errorColor),
            ),
            child: const Text(
              'خروج',
              style: RegistrationTextStyles.dialogTitleStyle,
            ),
          ),
        ],
      ),
    );
    return shouldExit ?? false;
  }
}