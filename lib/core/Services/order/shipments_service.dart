import 'dart:developer' as developer;
import 'package:Tosell/core/Model/order/orders/Shipment.dart';
import 'package:Tosell/core/Client/BaseClient.dart';
import 'package:Tosell/core/Client/ApiResponse.dart';
import 'package:Tosell/core/Client/APIendpoint.dart';

class ShipmentsService {
  final BaseClient<Shipment> baseClient;

  ShipmentsService()
      : baseClient =
            BaseClient<Shipment>(fromJson: (json) => Shipment.fromJson(json));

  Future<ApiResponse<Shipment>> getAll(
      {int page = 1, Map<String, dynamic>? queryParams}) async {
    try {
      var result = await baseClient.getAll(
          endpoint: ShipmentEndpoints.myShipments,
          page: page,
          queryParams: queryParams);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Shipment?> getShipmentById(String shipmentId) async {
    try {
      var result = await baseClient.getById(
          endpoint: ShipmentEndpoints.shipment, id: shipmentId);
      return result.singleData;
    } catch (e) {
      print('Error fetching shipment by ID: $e');
      return null;
    }
  }

  Future<(Shipment?, String?)> createShipment(Shipment shipmentData) async {
    try {
      var result = await baseClient.create(
          endpoint: ShipmentEndpoints.pickUp, data: shipmentData.toJson());

      if (result.code == 200 || result.code == 201) {
        return (result.singleData, null);
      } else {
        return (null, result.message ?? 'فشل في إنشاء الشحنة');
      }
    } catch (e) {
      return (null, e.toString());
    }
  }

  Future<(Shipment?, String?)> createPickupShipment(List<String> orderIds,
      {String? formType}) async {
    developer.log('🌐 بدء إرسال طلب إنشاء الشحنة إلى الخادم',
        name: 'ShipmentsService');
    developer.log('🔗 Endpoint: ${ShipmentEndpoints.pickUp}',
        name: 'ShipmentsService');
    developer.log('📤 معرفات الطلبات المرسلة: $orderIds',
        name: 'ShipmentsService');

    // تحضير البيانات بالتنسيق المطلوب من الخادم
    final ordersData = orderIds
        .map((orderId) => {
              'orderId': orderId,
            })
        .toList();

    final requestData = {
      'Orders': ordersData,
      'form': formType ?? 'pickup', // إضافة حقل form المطلوب
    };

    developer.log('📤 البيانات المرسلة: $requestData',
        name: 'ShipmentsService');

    try {
      developer.log('📡 إرسال الطلب...', name: 'ShipmentsService');
      final response = await baseClient.create(
        endpoint: ShipmentEndpoints.pickUp,
        data: requestData,
      );

      developer.log('📨 استلام الرد من الخادم:', name: 'ShipmentsService');
      developer.log('  - Status Code: ${response.code}',
          name: 'ShipmentsService');
      developer.log('  - Message: ${response.message}',
          name: 'ShipmentsService');
      developer.log('  - Has Single Data: ${response.hasSingle}',
          name: 'ShipmentsService');
      developer.log('  - Has List Data: ${response.hasList}',
          name: 'ShipmentsService');

      if (response.code == 200 || response.code == 201) {
        developer.log('✅ نجح الطلب (Status: ${response.code})',
            name: 'ShipmentsService');

        if (response.hasSingle && response.singleData != null) {
          developer.log('📦 تم استلام بيانات الشحنة بنجاح:',
              name: 'ShipmentsService');
          developer.log('  - معرف الشحنة: ${response.singleData!.id}',
              name: 'ShipmentsService');
          developer.log('  - رقم الشحنة: ${response.singleData!.code}',
              name: 'ShipmentsService');
          return (response.singleData, null);
        } else {
          developer.log('⚠️ لا توجد بيانات في الرد', name: 'ShipmentsService');
          final errorMessage = response.message ?? 'خطأ غير معروف';
          developer.log('❌ رسالة الخطأ: $errorMessage',
              name: 'ShipmentsService');
          return (null, errorMessage);
        }
      } else {
        developer.log('❌ فشل الطلب (Status: ${response.code})',
            name: 'ShipmentsService');
        final errorMessage = response.message ?? 'فشل في إنشاء الشحنة';
        developer.log('❌ رسالة الخطأ: $errorMessage', name: 'ShipmentsService');
        developer.log('❌ تفاصيل الأخطاء: ${response.errors}',
            name: 'ShipmentsService');
        return (null, errorMessage);
      }
    } catch (e) {
      developer.log('💥 خطأ في Service أثناء إنشاء الشحنة: $e',
          name: 'ShipmentsService');
      return (null, e.toString());
    }
  }

  Future<ApiResponse<dynamic>> getShipmentOrders({
    required String shipmentId,
    int page = 1,
  }) async {
    var result = await BaseClient().getAll(
      endpoint: ShipmentEndpoints.byId(shipmentId),
      page: page,
    );
    return result;
  }
}
