// lib/core/providers/auth/auth_provider.dart
import 'package:Tosell/core/api/client/BaseClient.dart';
import 'package:Tosell/core/model_core/User.dart';
import 'package:Tosell/core/utils/helpers/SharedPreferencesHelper.dart';
import 'package:Tosell/features/auth/auth_service.dart';
import 'package:Tosell/features/profile/data/models/zone.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class authNotifier extends _$authNotifier {
  final AuthService _service = AuthService();

  String _buildFullImageUrl(String imagePath) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    } else if (imagePath.startsWith('/')) {
      return '$imageUrl${imagePath.substring(1)}'; 
    } else {
      return '$imageUrl$imagePath';
    }
  }

  Future<(User? data, String? error)> register({
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
      state = const AsyncValue.loading();


      if (fullName.trim().isEmpty) {
        const errorMsg = 'اسم صاحب المتجر مطلوب';
        state = const AsyncValue.data(null);
        return (null, errorMsg);
      }

      if (brandName.trim().isEmpty) {
        const errorMsg = 'اسم المتجر مطلوب';
        state = const AsyncValue.data(null);
        print('❌ $errorMsg');
        return (null, errorMsg);
      }

      if (userName.trim().isEmpty) {
        const errorMsg = 'اسم المستخدم مطلوب';
        state = const AsyncValue.data(null);
        print('❌ $errorMsg');
        return (null, errorMsg);
      }

      if (phoneNumber.trim().isEmpty) {
        const errorMsg = 'رقم الهاتف مطلوب';
        state = const AsyncValue.data(null);
        print('❌ $errorMsg');
        return (null, errorMsg);
      }

      if (password.isEmpty) {
        const errorMsg = 'كلمة المرور مطلوبة';
        state = const AsyncValue.data(null);
        print('❌ $errorMsg');
        return (null, errorMsg);
      }

      print('🖼️ التحقق من صورة المتجر:');
      print('   - brandImg الأصلي: "$brandImg"');

      if (brandImg.trim().isEmpty) {
        const errorMsg = 'صورة المتجر مطلوبة';
        state = const AsyncValue.data(null);
        print('❌ $errorMsg');
        return (null, errorMsg);
      }

      final fullImageUrl = _buildFullImageUrl(brandImg);
     

      if (zones.isEmpty) {
        const errorMsg = 'يجب اختيار منطقة واحدة على الأقل';
        state = const AsyncValue.data(null);
        return (null, errorMsg);
      }
      final zonesData = <Map<String, dynamic>>[];
      for (int i = 0; i < zones.length; i++) {
        final zone = zones[i];
          if (zone.id == null || zone.id! <= 0) {
          final errorMsg = 'معرف المنطقة ${i + 1} غير صحيح';
          state = const AsyncValue.data(null);
          return (null, errorMsg);
        }
        final zoneData = {
          'zoneId': zone.id!,
          'nearestLandmark': nearestLandmark?.trim().isNotEmpty == true
              ? nearestLandmark!.trim()
              : 'نقطة مرجعية ${i + 1}',
          'long': longitude ?? 44.3661,
          'lat': latitude ?? 33.3152,
        };

        zonesData.add(zoneData);
      }
      final firstZoneType = zones.first.type ?? 1;
      final (user, error) = await _service.register(
        fullName: fullName.trim(),
        brandName: brandName.trim(),
        userName: userName.trim(),
        phoneNumber: phoneNumber.trim(),
        password: password,
        brandImg: fullImageUrl,
        zones: zonesData,
        type: firstZoneType,
      );

      if (error == "REGISTRATION_SUCCESS_PENDING_APPROVAL") {
        state = const AsyncValue.data(null);
        return (null, "REGISTRATION_SUCCESS_PENDING_APPROVAL");
      }

      if (user == null) {
        state = const AsyncValue.data(null);
        return (null, error);
      }
      await SharedPreferencesHelper.saveUser(user);
      state = AsyncValue.data(user);

      return (user, null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return (null, 'خطأ غير متوقع: ${e.toString()}');
    }
  }
  Future<(User? data, String? error)> login({
    String? phonNumber,
    required String passWord,
  }) async {
    try {
      state = const AsyncValue.loading();
      final (user, error) = await _service.login(
        phoneNumber: phonNumber,
        password: passWord,
      );
      if (user == null) {
        state = const AsyncValue.data(null);
        return (null, error);
      }

      // ✅ التحقق من حالة التفعيل
      if (error == "ACCOUNT_PENDING_ACTIVATION") {
        // الحساب في انتظار التفعيل
        print('⏳ AuthProvider: الحساب في انتظار التفعيل - ${user.fullName}');
        await SharedPreferencesHelper.saveUser(user);
        state = AsyncValue.data(user);
        return (user, "ACCOUNT_PENDING_ACTIVATION");
      }

      await SharedPreferencesHelper.saveUser(user);
      state = AsyncValue.data(user);
      return (user, error);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return (null, e.toString());
    }
  }

  @override
  FutureOr<void> build() async {
    return;
  }
}
