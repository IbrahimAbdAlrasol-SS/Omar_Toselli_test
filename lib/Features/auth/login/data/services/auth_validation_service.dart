import 'package:Tosell/features/profile/data/models/zone.dart';

class AuthValidationService {
  static String? validateFullName(String fullName) {
    if (fullName.trim().isEmpty) {
      return 'اسم صاحب المتجر مطلوب';
    }
    return null;
  }

  static String? validateBrandName(String brandName) {
    if (brandName.trim().isEmpty) {
      return 'اسم المتجر مطلوب';
    }
    return null;
  }

  static String? validateUserName(String userName) {
    if (userName.trim().isEmpty) {
      return 'اسم المستخدم مطلوب';
    }
    return null;
  }

  static String? validatePhoneNumber(String phoneNumber) {
    if (phoneNumber.trim().isEmpty) {
      return 'رقم الهاتف مطلوب';
    }
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }
    return null;
  }

  static String? validateBrandImage(String brandImg) {
    if (brandImg.trim().isEmpty) {
      return 'صورة المتجر مطلوبة';
    }
    return null;
  }

  static String? validateZones(List<Zone> zones) {
    if (zones.isEmpty) {
      return 'يجب اختيار منطقة واحدة على الأقل';
    }
    
    for (int i = 0; i < zones.length; i++) {
      final zone = zones[i];
      if (zone.id == null || zone.id! <= 0) {
        return 'معرف المنطقة ${i + 1} غير صحيح';
      }
    }
    
    return null;
  }

  static String? validateRegistrationData({
    required String fullName,
    required String brandName,
    required String userName,
    required String phoneNumber,
    required String password,
    required String brandImg,
    required List<Zone> zones,
  }) {
    String? error;
    
    error = validateFullName(fullName);
    if (error != null) return error;
    
    error = validateBrandName(brandName);
    if (error != null) return error;
    
    error = validateUserName(userName);
    if (error != null) return error;
    
    error = validatePhoneNumber(phoneNumber);
    if (error != null) return error;
    
    error = validatePassword(password);
    if (error != null) return error;
    
    error = validateBrandImage(brandImg);
    if (error != null) return error;
    
    error = validateZones(zones);
    if (error != null) return error;
    
    return null;
  }
}