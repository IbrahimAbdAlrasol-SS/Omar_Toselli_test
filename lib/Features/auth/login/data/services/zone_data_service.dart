import 'package:Tosell/features/profile/data/models/zone.dart';

class ZoneDataService {
  static List<Map<String, dynamic>> prepareZonesData({
    required List<Zone> zones,
    double? latitude,
    double? longitude,
    String? nearestLandmark,
  }) {
    final zonesData = <Map<String, dynamic>>[];
    
    for (int i = 0; i < zones.length; i++) {
      final zone = zones[i];
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
    
    return zonesData;
  }
  
  static int getFirstZoneType(List<Zone> zones) {
    return zones.first.type ?? 1;
  }
}