// lib/features/profile/data/services/zone_service.dart
import 'package:Tosell/core/api/client/BaseClient.dart';
import 'package:Tosell/features/profile/data/models/zone.dart';

class ZoneService {
  final BaseClient<Zone> _baseClient;

  ZoneService()
      : _baseClient = BaseClient<Zone>(fromJson: (json) => Zone.fromJson(json));

  // جلب جميع المناطق (بدون فلترة)
  Future<List<Zone>> getAllZones({int? pageSize}) async {
    try {
      print('🌍 ZoneService: جلب جميع المناطق...');
      
      // إضافة معاملات query للتأكد من جلب جميع البيانات
      final queryParams = <String, dynamic>{};
      if (pageSize != null) {
        queryParams['pageSize'] = pageSize;
      } else {
        // طلب عدد كبير من النتائج لضمان جلب جميع المناطق
        queryParams['pageSize'] = 1000;
      }
      
      final result = await _baseClient.getAll(
        endpoint: '/zone',
        queryParams: queryParams,
      );
      
      print('📊 تم جلب ${result.data?.length ?? 0} منطقة من الخادم');
      
      // طباعة إحصائيات المحافظات
      if (result.data != null && result.data!.isNotEmpty) {
        final governorateStats = <String, int>{};
        for (final zone in result.data!) {
          final govName = zone.governorate?.name ?? 'غير محدد';
          governorateStats[govName] = (governorateStats[govName] ?? 0) + 1;
        }
        
        print('📊 إحصائيات المناطق حسب المحافظة:');
        governorateStats.forEach((gov, count) {
          print('   - $gov: $count منطقة');
        });
      }
      
      return result.data ?? [];
    } catch (e) {
      print('❌ خطأ في جلب المناطق: $e');
      return [];
    }
  }

  // جلب مناطق محافظة محددة
  Future<List<Zone>> getZonesByGovernorate(int governorateId) async {
    try {
      print('🏛️ ZoneService: جلب مناطق المحافظة $governorateId...');
      
      // استخدام query parameter لفلترة المناطق حسب المحافظة
      final result = await _baseClient.getAll(
        endpoint: '/zone',
        queryParams: {
          'governorateId': governorateId,
          'pageSize': 500, // ضمان جلب جميع مناطق المحافظة
        },
      );
      
      print('📊 تم جلب ${result.data?.length ?? 0} منطقة للمحافظة $governorateId');
      
      return result.data ?? [];
    } catch (e) {
      print('❌ خطأ في جلب مناطق المحافظة: $e');
      return [];
    }
  }

  // جلب جميع المناطق مع pagination
  Future<List<Zone>> getAllZonesWithPagination({
    int page = 1,
    int pageSize = 100,
  }) async {
    try {
      List<Zone> allZones = [];
      int currentPage = 1;
      bool hasMorePages = true;
      
      print('🔄 بدء جلب جميع المناطق بـ pagination...');
      
      while (hasMorePages) {
        final result = await _baseClient.getAll(
          endpoint: '/zone',
          page: currentPage,
          queryParams: {
            'pageSize': pageSize,
          },
        );
        
        if (result.data != null && result.data!.isNotEmpty) {
          allZones.addAll(result.data!);
          print('📄 الصفحة $currentPage: تم جلب ${result.data!.length} منطقة');
          
          // التحقق من وجود صفحات إضافية
          if (result.pagination != null && 
              result.pagination!.currentPage! < result.pagination!.totalPages!) {
            currentPage++;
          } else {
            hasMorePages = false;
          }
        } else {
          hasMorePages = false;
        }
      }
      
      print('✅ إجمالي المناطق المجلوبة: ${allZones.length}');
      
      return allZones;
    } catch (e) {
      print('❌ خطأ في جلب المناطق مع pagination: $e');
      return [];
    }
  }

  // طريقة تشخيصية لفحص API
  Future<void> diagnoseZoneAPI() async {
    try {
      print('🔍 بدء تشخيص Zone API...');
      
      // 1. جلب بدون معاملات
      print('\n1️⃣ جلب بدون معاملات:');
      var result = await _baseClient.get(endpoint: '/zone');
      print('   - عدد النتائج: ${result.data?.length ?? 0}');
      
      // 2. جلب مع حجم صفحة كبير
      print('\n2️⃣ جلب مع pageSize=1000:');
      result = await _baseClient.getAll(
        endpoint: '/zone',
        queryParams: {'pageSize': 1000},
      );
      print('   - عدد النتائج: ${result.data?.length ?? 0}');
      
      // 3. فحص pagination
      print('\n3️⃣ فحص pagination:');
      if (result.pagination != null) {
        print('   - إجمالي العناصر: ${result.pagination!.totalItems}');
        print('   - إجمالي الصفحات: ${result.pagination!.totalPages}');
        print('   - حجم الصفحة: ${result.pagination!.pageSize}');
        print('   - الصفحة الحالية: ${result.pagination!.currentPage}');
      } else {
        print('   - لا توجد معلومات pagination');
      }
      
      // 4. فحص المحافظات الموجودة
      print('\n4️⃣ المحافظات الموجودة في النتائج:');
      if (result.data != null && result.data!.isNotEmpty) {
        final governorates = <int, String>{};
        for (final zone in result.data!) {
          if (zone.governorate?.id != null) {
            governorates[zone.governorate!.id!] = zone.governorate!.name ?? 'غير محدد';
          }
        }
        governorates.forEach((id, name) {
          print('   - المحافظة $id: $name');
        });
      }
      
    } catch (e) {
      print('❌ خطأ في التشخيص: $e');
    }
  }

  // البحث في المناطق
  Future<List<Zone>> searchZones(String query, {int? governorateId}) async {
    try {
      final queryParams = <String, dynamic>{
        'search': query,
        'pageSize': 100,
      };
      
      if (governorateId != null) {
        queryParams['governorateId'] = governorateId;
      }
      
      final result = await _baseClient.getAll(
        endpoint: '/zone',
        queryParams: queryParams,
      );
      
      return result.data ?? [];
    } catch (e) {
      print('❌ خطأ في البحث عن المناطق: $e');
      return [];
    }
  }
}