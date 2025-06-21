import 'dart:async';
import 'dart:developer' as developer;
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
    required List<String> shipmentData,
    String? formType,
  }) async {
    developer.log('🔄 بدء عملية إنشاء الشحنة في Provider',
        name: 'ShipmentsProvider');
    developer.log('📋 معرفات الطلبات المستلمة: $shipmentData',
        name: 'ShipmentsProvider');
    developer.log('📋 نوع النموذج: ${formType ?? "pickup"}',
        name: 'ShipmentsProvider');

    try {
      developer.log('📞 استدعاء خدمة إنشاء الشحنة...',
          name: 'ShipmentsProvider');
      final result =
          await _service.createPickupShipment(shipmentData, formType: formType);

      developer.log('📥 نتيجة خدمة إنشاء الشحنة:', name: 'ShipmentsProvider');
      developer.log('  - نجح الإنشاء: ${result.$1 != null}',
          name: 'ShipmentsProvider');
      developer.log('  - رسالة الخطأ: ${result.$2 ?? "لا يوجد"}',
          name: 'ShipmentsProvider');

      if (result.$1 != null) {
        developer.log('✅ تم إنشاء الشحنة بنجاح، تحديث البيانات...',
            name: 'ShipmentsProvider');
        developer.log('  - معرف الشحنة: ${result.$1!.id}',
            name: 'ShipmentsProvider');
        developer.log('  - رقم الشحنة: ${result.$1!.code}',
            name: 'ShipmentsProvider');
        ref.invalidateSelf();
      } else {
        developer.log('❌ فشل في إنشاء الشحنة: ${result.$2}',
            name: 'ShipmentsProvider');
      }

      return result;
    } catch (e) {
      developer.log('💥 خطأ في Provider أثناء إنشاء الشحنة: $e',
          name: 'ShipmentsProvider');
      return (null, e.toString());
    }
  }

  @override
  FutureOr<List<Shipment>> build() async {
    var result = await getAll();
    return result.data ?? [];
  }
}
