import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Tosell/core/utils/helpers/SharedPreferencesHelper.dart';
import 'package:Tosell/features/auth/auth_service.dart';
import '../../domain/entities/activation_timer_state.dart';
import '../../data/services/activation_timer_service.dart';
import '../../data/services/token_decoder_service.dart';

final activationTimerProvider = StateNotifierProvider.autoDispose<ActivationTimerNotifier, ActivationTimerState>((ref) {
  return ActivationTimerNotifier(ref);
});

class ActivationTimerNotifier extends StateNotifier<ActivationTimerState> {
  final AutoDisposeStateNotifierProviderRef _ref;
  Timer? _timer;
  Timer? _activationCheckTimer;
  final AuthService _authService = AuthService();
  bool _isDisposed = false;
  
  ActivationTimerNotifier(this._ref) : super(ActivationTimerState.initial()) {
    _initialize();
  }
  
  Future<void> _initialize() async {
    if (_isDisposed) return;
    
    // جلب وقت التسجيل من SharedPreferences
    final registrationTime = await ActivationTimerService.getRegistrationTime();
    
    if (_isDisposed) return;
    
    if (registrationTime != null) {
      final remainingTime = ActivationTimerService.calculateRemainingTime(registrationTime);
      final isExpired = ActivationTimerService.isTimerExpired(registrationTime);
      
      if (!_isDisposed) {
        state = state.copyWith(
          registrationTime: registrationTime,
          remainingTime: remainingTime,
          isExpired: isExpired,
        );
      }
      
      if (!isExpired && !_isDisposed) {
        _startTimer();
      }
    }
    
    // بدء فحص التفعيل الدوري
    if (!_isDisposed) {
      _startActivationCheck();
    }
  }
  
  void _startTimer() {
    if (_isDisposed) return;
    
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isDisposed) {
        timer.cancel();
        return;
      }
      
      final remaining = ActivationTimerService.calculateRemainingTime(state.registrationTime);
      
      if (remaining == Duration.zero) {
        if (!_isDisposed) {
          state = state.copyWith(
            remainingTime: Duration.zero,
            isExpired: true,
          );
        }
        timer.cancel();
      } else {
        if (!_isDisposed) {
          state = state.copyWith(remainingTime: remaining);
        }
      }
    });
  }
  
  void _startActivationCheck() {
    if (_isDisposed) return;
    
    // فحص كل 5 ثواني
    _activationCheckTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (_isDisposed) {
        timer.cancel();
        return;
      }
      
      await checkActivationStatus();
    });
  }
  
  Future<bool> checkActivationStatus() async {
    if (_isDisposed) return false;
    
    try {
      // الحصول على المستخدم المحفوظ
      final user = await SharedPreferencesHelper.getUser();
      if (user == null || user.token == null) {
        print('❌ لا يوجد مستخدم أو توكن محفوظ');
        return false;
      }
      
      if (_isDisposed) return false;
      
      // فحص حالة التفعيل من التوكن
      final isActiveFromToken = TokenDecoderService.getIsActiveFromToken(user.token);
      
      print('🔍 فحص التفعيل من التوكن:');
      print('   - IsActive من التوكن: $isActiveFromToken');
      print('   - IsActive من المستخدم: ${user.isActive}');
      
      // إذا كان التوكن يشير إلى أن الحساب غير مفعل، نحتاج لتسجيل دخول جديد
      if (isActiveFromToken == false && state.isActive == false) {
        return false;
      }
      
      // إذا كان التوكن يشير إلى أن الحساب مفعل
      if (isActiveFromToken == true && !state.isActive) {
        print('✅ الحساب مفعل الآن!');
        
        if (!_isDisposed) {
          state = state.copyWith(isActive: true);
        }
        
        // تحديث بيانات المستخدم
        user.isActive = true;
        await SharedPreferencesHelper.saveUser(user);
        
        // مسح وقت التسجيل
        await ActivationTimerService.clearRegistrationTime();
        
        // إيقاف المؤقتات
        _timer?.cancel();
        _activationCheckTimer?.cancel();
        
        return true;
      }
      
      return false;
    } catch (e) {
      print('💥 خطأ في فحص التفعيل: $e');
      return false;
    }
  }
  
  // بدء مؤقت جديد عند التسجيل
  Future<void> startNewTimer() async {
    if (_isDisposed) return;
    
    // التحقق من وجود وقت تسجيل سابق
    final existingRegistrationTime = await ActivationTimerService.getRegistrationTime();
    
    DateTime registrationTime;
    
    if (existingRegistrationTime != null) {
      registrationTime = existingRegistrationTime;
      print('📅 استخدام وقت التسجيل الموجود: $registrationTime');
    } else {
      registrationTime = DateTime.now();
      await ActivationTimerService.saveRegistrationTime(registrationTime);
      print('📅 حفظ وقت تسجيل جديد: $registrationTime');
    }
    
    final remainingTime = ActivationTimerService.calculateRemainingTime(registrationTime);
    final isExpired = ActivationTimerService.isTimerExpired(registrationTime);
    
    if (!_isDisposed) {
      state = ActivationTimerState(
        registrationTime: registrationTime,
        remainingTime: remainingTime,
        isExpired: isExpired,
        isActive: false,
      );
    }
    
    if (!_isDisposed && !isExpired) {
      _startTimer();
      _startActivationCheck();
    }
  }
  
  @override
  void dispose() {
    _isDisposed = true;
    _timer?.cancel();
    _activationCheckTimer?.cancel();
    super.dispose();
  }
}