import 'package:Tosell/core/model_core/User.dart';
import 'package:Tosell/core/utils/helpers/SharedPreferencesHelper.dart';
import 'package:Tosell/features/auth/auth_service.dart';

class LoginHandler {
  final AuthService _service;
  
  LoginHandler(this._service);
  
  Future<(User? data, String? error)> handleLogin({
    String? phoneNumber,
    required String password,
  }) async {
    final (user, error) = await _service.login(
      phoneNumber: phoneNumber,
      password: password,
    );
    
    if (user == null) {
      return (null, error);
    }

    await SharedPreferencesHelper.saveUser(user);
    
    if (error == "ACCOUNT_PENDING_ACTIVATION") {
      return (user, "ACCOUNT_PENDING_ACTIVATION");
    }

    return (user, error);
  }
}