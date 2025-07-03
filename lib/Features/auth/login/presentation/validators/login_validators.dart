import '../constants/login_strings.dart';

class LoginValidators {
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return LoginStrings.phoneValidationError;
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return LoginStrings.passwordValidationError;
    }
    return null;
  }
}