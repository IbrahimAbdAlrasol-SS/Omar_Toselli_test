import 'package:Tosell/core/model_core/User.dart';
import 'package:Tosell/core/utils/helpers/SharedPreferencesHelper.dart';
import 'package:Tosell/features/auth/auth_service.dart';
import 'package:Tosell/features/profile/data/models/zone.dart';
import '../services/auth_validation_service.dart';
import '../services/image_url_service.dart';
import '../services/zone_data_service.dart';

class RegistrationHandler {
  final AuthService _service;
  
  RegistrationHandler(this._service);
  
  Future<(User? data, String? error)> handleRegistration({
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
    final validationError = AuthValidationService.validateRegistrationData(
      fullName: fullName,
      brandName: brandName,
      userName: userName,
      phoneNumber: phoneNumber,
      password: password,
      brandImg: brandImg,
      zones: zones,
    );
    
    if (validationError != null) {
      return (null, validationError);
    }
    
    final fullImageUrl = ImageUrlService.buildFullImageUrl(brandImg);
    
    final zonesData = ZoneDataService.prepareZonesData(
      zones: zones,
      latitude: latitude,
      longitude: longitude,
      nearestLandmark: nearestLandmark,
    );
    
    final firstZoneType = ZoneDataService.getFirstZoneType(zones);
    
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
      return (null, "REGISTRATION_SUCCESS_PENDING_APPROVAL");
    }

    if (user == null) {
      return (null, error);
    }
    
    await SharedPreferencesHelper.saveUser(user);
    return (user, null);
  }
}