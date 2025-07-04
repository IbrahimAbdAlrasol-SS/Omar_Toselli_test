// lib/Features/auth/registration/presentation/validators/user_info_validators.dart
class UserInfoValidators {
  static String? validateOwnerName(String? value) {
    if (value?.trim().isEmpty ?? true) {
      return "اسم صاحب المتجر مطلوب";
    }
    if (value!.trim().length < 2) {
      return "اسم صاحب المتجر قصير جداً";
    }
    return null;
  }

  static String? validateStoreName(String? value) {
    if (value?.trim().isEmpty ?? true) {
      return "اسم المتجر مطلوب";
    }
    if (value!.trim().length < 2) {
      return "اسم المتجر قصير جداً";
    }
    return null;
  }

  static String? validateUserName(String? value) {
    if (value?.trim().isEmpty ?? true) {
      return "اسم المستخدم مطلوب";
    }
    if (value!.trim().length < 3) {
      return "اسم المستخدم قصير جداً";
    }
    final hasLetters = RegExp(r'[a-zA-Z\u0600-\u06FF]').hasMatch(value);
    if (!hasLetters) {
      return "اسم المستخدم يجب أن يحتوي على أحرف";
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value?.trim().isEmpty ?? true) {
      return "رقم الهاتف مطلوب";
    }
    final phoneRegex = RegExp(r'^(07[0-9]{9}|07[0-9]{8})$');
    if (!phoneRegex.hasMatch(value!.replaceAll(' ', ''))) {
      return "رقم الهاتف غير صحيح";
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value?.isEmpty ?? true) {
      return "كلمة المرور مطلوبة";
    }
    if (value!.length < 6) {
      return "كلمة المرور قصيرة جداً (6 أحرف على الأقل)";
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value?.isEmpty ?? true) {
      return "تأكيد كلمة المرور مطلوب";
    }
    if (value != password) {
      return "كلمة المرور غير متطابقة";
    }
    return null;
  }

  static String? validateStoreImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return "صورة المتجر مطلوبة";
    }
    return null;
  }
}
