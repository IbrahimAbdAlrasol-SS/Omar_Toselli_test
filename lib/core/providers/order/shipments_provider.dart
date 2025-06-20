import 'dart:async';
import 'package:Tosell/core/Model/order/orders/Shipment.dart';
import 'package:Tosell/core/Services/order/shipments_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:Tosell/core/Client/ApiResponse.dart';
import 'package:Tosell/core/Model/order/add_order_form.dart';

part 'shipments_provider.g.dart';

@riverpod
class ShipmentsNotifier extends _$ShipmentsNotifier {
  final ShipmentsService _service = ShipmentsService();

  Future<ApiResponse<Shipment>> getAll(
      {int page = 1, Map<String, dynamic>? queryParams}) async {
    return (await _service.getAll(queryParams: queryParams, page: page));
  }

  Future<(Shipment?, String?)> createShipment({
    required Map<String, dynamic> shipmentData,
  }) async {
    try {
      final result = await _service.createPickupShipment(shipmentData);
      if (result.$1 != null) {
        // تحديث قائمة الشحنات بعد إنشاء شحنة جديدة
        ref.invalidateSelf();
      }
      return result;
    } catch (e) {
      return (null, e.toString());
    }
  }

  @override
  FutureOr<List<Shipment>> build() async {
    var result = await getAll();
    return result.data ?? [];
  }
}