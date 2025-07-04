
// lib/Features/auth/pending_activation/data/services/activation_timer_service.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivationTimerService {
  static const String _registrationTimeKey = 'registration_time';
  static const Duration _activationPeriod = Duration(hours: 24);
  
  // حفظ وقت التسجيل
  static Future<void> saveRegistrationTime(DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_registrationTimeKey, time.toIso8601String());
  }
  
  // جلب وقت التسجيل
  static Future<DateTime?> getRegistrationTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timeString = prefs.getString(_registrationTimeKey);
    if (timeString != null) {
      return DateTime.parse(timeString);
    }
    return null;
  }
  
  // حساب الوقت المتبقي
  static Duration calculateRemainingTime(DateTime registrationTime) {
    final now = DateTime.now();
    final elapsed = now.difference(registrationTime);
    final remaining = _activationPeriod - elapsed;
    
    return remaining.isNegative ? Duration.zero : remaining;
  }
  
  // التحقق من انتهاء المهلة
  static bool isTimerExpired(DateTime registrationTime) {
    final remaining = calculateRemainingTime(registrationTime);
    return remaining == Duration.zero;
  }
  
  // مسح وقت التسجيل (عند التفعيل)
  static Future<void> clearRegistrationTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_registrationTimeKey);
  }
}