// lib/core/providers/auth/pending_activation_provider.dart
import 'dart:async';
import 'package:Tosell/core/Services/_auth/PendingActivationService.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:Tosell/core/Model/auth/PendingActivation.dart';
import 'package:Tosell/core/helpers/SharedPreferencesHelper.dart';

part 'pending_activation_provider.g.dart';

@riverpod
class PendingActivationNotifier extends _$PendingActivationNotifier {
  final PendingActivationService _service = PendingActivationService();
  Timer? _countdownTimer;
  Timer? _statusCheckTimer;

  @override
  Future<PendingActivation?> build() async {
    // محاولة جلب البيانات من الخادم
    final result = await _service.getPendingActivationStatus();
    
    if (result['data'] != null) {
      _startCountdownTimer();
      _startStatusCheckTimer();
      return result['data'];
    } else {
      // في حالة عدم توفر الخادم، استخدام البيانات الوهمية
      final user = await SharedPreferencesHelper.getUser();
      final mockData = _service.createMockData(
        fullName: user?.fullName,
        brandName: user?.userName, // أو أي حقل آخر يحتوي على اسم المتجر
        phoneNumber: user?.phoneNumber,
      );
      _startCountdownTimer();
      return mockData;
    }
  }

  /// بدء العداد التنازلي
  void _startCountdownTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final currentState = state.value;
      if (currentState != null) {
        final remainingTime = currentState.calculateRemainingTime();
        
        if (remainingTime == null || remainingTime.isNegative) {
          // انتهت المدة
          timer.cancel();
          state = AsyncValue.data(
            currentState.copyWith(
              remainingTime: Duration.zero,
              isExpired: true,
            ),
          );
        } else {
          // تحديث الوقت المتبقي
          state = AsyncValue.data(
            currentState.copyWith(
              remainingTime: remainingTime,
              isExpired: false,
            ),
          );
        }
      }
    });
  }

  /// بدء فحص حالة التفعيل دورياً
  void _startStatusCheckTimer() {
    _statusCheckTimer?.cancel();
    _statusCheckTimer = Timer.periodic(const Duration(minutes: 5), (timer) async {
      await checkActivationStatus();
    });
  }

  /// التحقق من حالة التفعيل
  Future<bool> checkActivationStatus() async {
    try {
      final result = await _service.checkActivationStatus();
      if (result['isActivated'] == true) {
        // تم تفعيل الحساب
        _stopAllTimers();
        return true;
      }
      return false;
    } catch (e) {
      print('خطأ في فحص حالة التفعيل: $e');
      return false;
    }
  }

  /// تسجيل الخروج
  Future<Map<String, dynamic>> logout() async {
    try {
      _stopAllTimers();
      final result = await _service.logout();
      if (result['success'] == true) {
        state = const AsyncValue.data(null);
      }
      return result;
    } catch (e) {
      return {'success': false, 'error': 'حدث خطأ أثناء تسجيل الخروج'};
    }
  }

  /// التواصل مع الدعم الفني
  Future<Map<String, dynamic>> contactSupport({
    required String message,
    String? contactMethod,
  }) async {
    try {
      return await _service.contactSupport(
        message: message,
        contactMethod: contactMethod ?? '',
      );
    } catch (e) {
      return {'success': false, 'error': 'حدث خطأ أثناء إرسال الرسالة'};
    }
  }

  /// إيقاف جميع المؤقتات
  void _stopAllTimers() {
    _countdownTimer?.cancel();
    _statusCheckTimer?.cancel();
  }

  /// تحديث البيانات يدوياً
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final result = await _service.getPendingActivationStatus();
    
    if (result['data'] != null) {
      state = AsyncValue.data(result['data']);
      _startCountdownTimer();
      _startStatusCheckTimer();
    } else {
      // استخدام البيانات الوهمية في حالة الفشل
      final user = await SharedPreferencesHelper.getUser();
      final mockData = _service.createMockData(
        fullName: user?.fullName,
        brandName: user?.userName,
        phoneNumber: user?.phoneNumber,
      );
      state = AsyncValue.data(mockData);
      _startCountdownTimer();
    }
  }

  /// الحصول على الوقت المتبقي بتنسيق نصي
  String get formattedRemainingTime {
    final currentState = state.value;
    if (currentState == null) return "00:00:00";
    return currentState.formattedRemainingTime;
  }

  /// التحقق من انتهاء المدة
  bool get isExpired {
    final currentState = state.value;
    if (currentState == null) return false;
    return currentState.isActivationExpired;
  }

  /// الحصول على الساعات المتبقية
  int get remainingHours {
    final currentState = state.value;
    if (currentState == null) return 0;
    final remaining = currentState.calculateRemainingTime();
    if (remaining == null || remaining.isNegative) return 0;
    return remaining.inHours;
  }

  /// الحصول على الدقائق المتبقية
  int get remainingMinutes {
    final currentState = state.value;
    if (currentState == null) return 0;
    final remaining = currentState.calculateRemainingTime();
    if (remaining == null || remaining.isNegative) return 0;
    return remaining.inMinutes % 60;
  }

  /// الحصول على الثواني المتبقية
  int get remainingSeconds {
    final currentState = state.value;
    if (currentState == null) return 0;
    final remaining = currentState.calculateRemainingTime();
    if (remaining == null || remaining.isNegative) return 0;
    return remaining.inSeconds % 60;
  }

  void dispose() {
    _stopAllTimers();
  }
}