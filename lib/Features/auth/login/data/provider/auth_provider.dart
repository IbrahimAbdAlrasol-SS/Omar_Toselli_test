import 'package:Tosell/core/model_core/User.dart';
import 'package:Tosell/features/auth/auth_service.dart';
import 'package:Tosell/features/profile/data/models/zone.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../handlers/registration_handler.dart';
import '../handlers/login_handler.dart';

part 'auth_provider.g.dart';

@riverpod
class authNotifier extends _$authNotifier {
  final AuthService _service = AuthService();
  late final RegistrationHandler _registrationHandler;
  late final LoginHandler _loginHandler;
  
  @override
  FutureOr<void> build() async {
    _registrationHandler = RegistrationHandler(_service);
    _loginHandler = LoginHandler(_service);
    return;
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
      
      final result = await _registrationHandler.handleRegistration(
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
      
      if (result.$1 != null) {
        state = AsyncValue.data(result.$1);
      } else {
        state = const AsyncValue.data(null);
      }
      
      return result;
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
      
      final result = await _loginHandler.handleLogin(
        phoneNumber: phonNumber,
        password: passWord,
      );
      
      if (result.$1 != null) {
        state = AsyncValue.data(result.$1);
      } else {
        state = const AsyncValue.data(null);
      }
      
      return result;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return (null, e.toString());
    }
  }
}