

import 'package:Tosell/core/api/client/BaseClient.dart';
import 'package:Tosell/core/api/endpoints/APIendpoint.dart';
import 'package:Tosell/features/profile/data/models/zone.dart';

class ZoneService {
  final BaseClient<Zone> baseClient;

  ZoneService()
      : baseClient = BaseClient<Zone>(fromJson: (json) => Zone.fromJson(json));

  /// جلب جميع المناطق من الباك اند
  Future<List<Zone>> getAllZones(
      {Map<String, dynamic>? queryParams, int page = 1}) async {
    try {
      print('🌐 ZoneService: بدء جلب المناطق من ${ProfileEndpoints.zone}');
      var result = await baseClient.getAll(
          endpoint: ProfileEndpoints.zone,
          page: page,
          queryParams: queryParams);

      print('📊 ZoneService: استجابة API - الرسالة: ${result.message}');
      print('📊 ZoneService: عدد المناطق المُستلمة: ${result.data?.length ?? 0}');
      
      if (result.data == null) {
        print('❌ ZoneService: لا توجد بيانات في الاستجابة');
        return [];
      }

      // طباعة عينة من المناطق المُستلمة مع محافظاتها
      for (int i = 0; i < result.data!.length && i < 5; i++) {
        final zone = result.data![i];
        print('   المنطقة ${i + 1}: ${zone.name} (معرف: ${zone.id})');
        print('     - المحافظة: ${zone.governorate?.name} (معرف: ${zone.governorate?.id})');
      }
      
      if (result.data!.length > 5) {
        print('   ... و ${result.data!.length - 5} منطقة أخرى');
      }
      
      // إحصائيات المحافظات
      final governorateStats = <String, int>{};
      for (final zone in result.data!) {
        final govName = zone.governorate?.name ?? 'غير محدد';
        governorateStats[govName] = (governorateStats[govName] ?? 0) + 1;
      }
      
      print('📈 إحصائيات المناطق حسب المحافظة:');
      governorateStats.forEach((govName, count) {
        print('   $govName: $count منطقة');
      });

      return result.data!;
    } catch (e) {
      print('❌ ZoneService: خطأ في جلب المناطق: $e');
      rethrow;
    }
  }

  /// جلب المناطق حسب ID المحافظة مع إمكانية البحث
  Future<List<Zone>> getZonesByGovernorateId(
      {required int governorateId, String? query, int page = 1}) async {
    try {
      // جلب جميع المناطق أولاً
      var allZones = await getAllZones(page: page);

      // تصفية المناطق حسب المحافظة
      var filteredZones = allZones.where((zone) {
        return zone.governorate?.id == governorateId;
      }).toList();

      // تطبيق البحث إذا كان موجوداً
      if (query != null && query.trim().isNotEmpty) {
        filteredZones = filteredZones
            .where((zone) =>
                zone.name?.toLowerCase().contains(query.toLowerCase()) ?? false)
            .toList();
      }

      return filteredZones;
    } catch (e) {
      rethrow;
    }
  }

  /// جلب مناطق محددة حسب قائمة من الـ IDs
  Future<List<Zone>> getZonesByIds(List<int> zoneIds) async {
    try {
      final allZones = await getAllZones();
      final filteredZones =
          allZones.where((zone) => zoneIds.contains(zone.id)).toList();

      return filteredZones;
    } catch (e) {
      rethrow;
    }
  }

  /// البحث في المناطق بالاسم
  Future<List<Zone>> searchZones(String query, {int page = 1}) async {
    try {
      if (query.trim().isEmpty) {
        return await getAllZones(page: page);
      }

      final allZones = await getAllZones(page: page);
      final searchResults = allZones
          .where((zone) =>
              zone.name?.toLowerCase().contains(query.toLowerCase()) ?? false)
          .toList();

      return searchResults;
    } catch (e) {
      rethrow;
    }
  }

  /// جلب المناطق الخاصة بالتاجر الحالي
  Future<List<Zone>> getMyZones() async {
    try {
      // لهذا endpoint نحتاج ZoneObject لأنه يرجع { zone: {...} }
      final zoneObjectClient =
          BaseClient<ZoneObject>(fromJson: (json) => ZoneObject.fromJson(json));

      var result =
          await zoneObjectClient.get(endpoint: ProfileEndpoints.merchantZones);

      if (result.data == null) {
        return [];
      }

      final zones = result.data!.map((e) => e.zone!).toList();
      return zones;
    } catch (e) {
      rethrow;
    }
  }
}
