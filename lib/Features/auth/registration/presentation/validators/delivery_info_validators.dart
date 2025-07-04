
// lib/Features/auth/registration/presentation/validators/delivery_info_validators.dart
import 'package:Tosell/features/profile/data/models/zone.dart';

class DeliveryInfoValidators {
  static String? validateGovernorate(Governorate? governorate) {
    if (governorate == null) {
      return "المحافظة مطلوبة";
    }
    return null;
  }

  static String? validateZone(Zone? zone) {
    if (zone == null) {
      return "المنطقة مطلوبة";
    }
    return null;
  }

  static String? validateNearestLandmark(String? value) {
    if (value?.trim().isEmpty ?? true) {
      return "أقرب نقطة دالة مطلوبة";
    }
    return null;
  }

  static String? validateLocation(double? latitude, double? longitude) {
    if (latitude == null || longitude == null) {
      return "يجب تحديد الموقع على الخريطة";
    }
    return null;
  }

  static bool validateZoneInfo(ZoneLocationInfo zoneInfo) {
    return zoneInfo.selectedZone != null &&
           zoneInfo.nearestLandmark.isNotEmpty &&
           zoneInfo.latitude != null &&
           zoneInfo.longitude != null;
  }

  static String? validateZonesList(List<ZoneLocationInfo> zones) {
    if (zones.isEmpty) {
      return "يجب إضافة منطقة واحدة على الأقل";
    }

    for (int i = 0; i < zones.length; i++) {
      if (!validateZoneInfo(zones[i])) {
        return "يجب إكمال معلومات المنطقة ${i + 1}";
      }
    }

    return null;
  }
}

// Note: ZoneLocationInfo class is defined in delivery_info_tab.dart
// This import will be needed when implementing
class ZoneLocationInfo {
  final Governorate? selectedGovernorate;
  final Zone? selectedZone;
  final String nearestLandmark;
  final double? latitude;
  final double? longitude;

  ZoneLocationInfo({
    this.selectedGovernorate,
    this.selectedZone,
    this.nearestLandmark = '',
    this.latitude,
    this.longitude,
  });
}