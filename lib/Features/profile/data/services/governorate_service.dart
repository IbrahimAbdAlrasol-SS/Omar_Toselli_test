
import 'package:Tosell/core/api/client/BaseClient.dart';
import 'package:Tosell/core/api/endpoints/APIendpoint.dart';
import 'package:Tosell/features/profile/data/models/zone.dart';

class GovernorateService {
  final BaseClient<Governorate> baseClient;

  GovernorateService()
      : baseClient = BaseClient<Governorate>(
            fromJson: (json) => Governorate.fromJson(json));
  Future<List<Governorate>> getAllZones(
      {Map<String, dynamic>? queryParams, int page = 1}) async {
    try {
      print('🌐 GovernorateService: بدء جلب المحافظات من ${ProfileEndpoints.governorate}');
      var result = await baseClient.getAll(
          endpoint: ProfileEndpoints.governorate,
          page: page,
          queryParams: queryParams);

      print('📊 GovernorateService: استجابة API - الرسالة: ${result.message}');
      print('📊 GovernorateService: عدد المحافظات المُستلمة: ${result.data?.length ?? 0}');
      
      if (result.data == null) {
        print('❌ GovernorateService: لا توجد بيانات في الاستجابة');
        return [];
      }

      for (int i = 0; i < result.data!.length && i < 5; i++) {
        final gov = result.data![i];
        print('   المحافظة ${i + 1}: ${gov.name} (معرف: ${gov.id})');
      }
      
      if (result.data!.length > 5) {
        print('   ... و ${result.data!.length - 5} محافظة أخرى');
      }

      return result.data!;
    } catch (e) {
      print('❌ GovernorateService: خطأ في جلب المحافظات: $e');
      rethrow;
    }
  }

  Future<List<Governorate>> searchGovernorates(String query,
      {int page = 1}) async {
    try {
      if (query.trim().isEmpty) {
        return await getAllZones(page: page);
      }

      final allGovernorates = await getAllZones(page: page);
      final searchResults = allGovernorates
          .where((gov) =>
              gov.name?.toLowerCase().contains(query.toLowerCase()) ?? false)
          .toList();

      return searchResults;
    } catch (e) {
      rethrow;
    }
  }

  Future<Governorate?> getGovernorateById(int id) async {
    try {
      final result = await baseClient.getById(
        endpoint: ProfileEndpoints.governorate,
        id: id.toString(),
      );

      return result.getSingle;
    } catch (e) {
      rethrow;
    }
  }
}
