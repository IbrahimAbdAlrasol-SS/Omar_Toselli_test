// lib/features/profile/data/services/governorate_service.dart
import 'package:Tosell/core/api/client/BaseClient.dart';
import 'package:Tosell/core/api/endpoints/APIendpoint.dart';
import 'package:Tosell/features/profile/data/models/zone.dart';

class GovernorateService {
  final BaseClient<Governorate> _baseClient;

  GovernorateService()
      : _baseClient = BaseClient<Governorate>(
            fromJson: (json) => Governorate.fromJson(json));

  // البحث عن المحافظات مع دعم البحث النصي
  Future<List<Governorate>> searchGovernorates({
    String? searchQuery,
    int pageSize = 100,
    int page = 1,
  }) async {
    try {
      print('🔍 GovernorateService: البحث عن المحافظات...');
      print('   - نص البحث: "$searchQuery"');
      print('   - حجم الصفحة: $pageSize');
      print('   - رقم الصفحة: $page');

      // إعداد معاملات الاستعلام
      final queryParams = <String, dynamic>{
        'pageSize': pageSize,
        'pageNumber': page,
      };

      // إضافة معامل البحث إذا كان موجوداً
      if (searchQuery != null && searchQuery.isNotEmpty) {
        // محاولة معاملات بحث مختلفة حسب API
        queryParams['search'] = searchQuery; // أو
        queryParams['name'] = searchQuery; // أو
        queryParams['q'] = searchQuery; // أو
        queryParams['filter'] = searchQuery;
      }

      final result = await _baseClient.getAll(
        endpoint: ProfileEndpoints.governorate,
        page: page,
        queryParams: queryParams,
      );

      print('✅ تم جلب ${result.data?.length ?? 0} محافظة');
      
      // طباعة أسماء ال, required String searchQueryمحافظات المُرجعة
      if (result.data != null && result.data!.isNotEmpty) {
        print('📋 المحافظات المُرجعة:');
        for (var gov in result.data!) {
          print('   - ${gov.name} (ID: ${gov.id})');
        }
      }

      // إذا كان هناك بحث محلي إضافي (في حالة عدم دعم API للبحث)
      if (searchQuery != null && searchQuery.isNotEmpty && result.data != null) {
        final filtered = result.data!.where((gov) {
          final name = gov.name?.toLowerCase() ?? '';
          final query = searchQuery.toLowerCase();
          return name.contains(query);
        }).toList();
        
        print('🔍 بعد الفلترة المحلية: ${filtered.length} محافظة');
        return filtered;
      }

      return result.data ?? [];
    } catch (e) {
      print('❌ خطأ في البحث عن المحافظات: $e');
      return [];
    }
  }

  // جلب جميع المحافظات مع pagination كامل
  Future<List<Governorate>> getAllGovernorates() async {
    try {
      List<Governorate> allGovernorates = [];
      int currentPage = 1;
      bool hasMorePages = true;
      
      print('🔄 بدء جلب جميع المحافظات بـ pagination...');
      
      while (hasMorePages) {
        final result = await searchGovernorates(
          pageSize: 50,
          page: currentPage,
        );
        
        if (result.isNotEmpty) {
          allGovernorates.addAll(result);
          print('📄 الصفحة $currentPage: تم جلب ${result.length} محافظة');
          
          // إذا كان عدد النتائج أقل من حجم الصفحة، فلا توجد صفحات إضافية
          if (result.length < 50) {
            hasMorePages = false;
          } else {
            currentPage++;
          }
        } else {
          hasMorePages = false;
        }
        
        // حماية من الحلقة اللانهائية
        if (currentPage > 20) {
          print('⚠️ تم الوصول للحد الأقصى من الصفحات');
          break;
        }
      }
      
      print('✅ إجمالي المحافظات المجلوبة: ${allGovernorates.length}');
      
      // إزالة التكرارات إن وجدت
      final uniqueGovernorates = <int, Governorate>{};
      for (var gov in allGovernorates) {
        if (gov.id != null) {
          uniqueGovernorates[gov.id!] = gov;
        }
      }
      
      return uniqueGovernorates.values.toList();
    } catch (e) {
      print('❌ خطأ في جلب جميع المحافظات: $e');
      return [];
    }
  }

  // الطريقة القديمة للتوافق
  Future<List<Governorate>> getAllZones() async {
    return getAllGovernorates();
  }
}