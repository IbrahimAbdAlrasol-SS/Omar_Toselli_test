
import 'package:Tosell/core/api/client/BaseClient.dart';
import 'package:Tosell/core/api/endpoints/APIendpoint.dart';
import 'package:Tosell/features/profile/data/models/zone.dart';

class ZonePriceService {
  final BaseClient<Zone> baseClient;

  ZonePriceService()
      : baseClient = BaseClient<Zone>(fromJson: (json) => Zone.fromJson(json));

  Future<List<Zone>> getAllZones(
      {required String governorateId, int page = 1}) async {
    try {
      var result = await baseClient.getAll(
          endpoint: ProfileEndpoints.zone,
          page: page,
          queryParams: {'governorateId': governorateId});
      if (result.data == null) return [];
      return result.data ?? [];
    } catch (e) {
      rethrow;
    }
  }
}
