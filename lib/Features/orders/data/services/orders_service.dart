
import 'dart:developer' as developer;

import 'package:Tosell/core/api/client/ApiResponse.dart';
import 'package:Tosell/core/api/client/BaseClient.dart';
import 'package:Tosell/core/api/endpoints/APIendpoint.dart';
import 'package:Tosell/features/order/data/models/add_order_form.dart';
import 'package:Tosell/features/orders/data/models/Order.dart';

class OrdersService {
  final BaseClient<Order> baseClient;

  OrdersService()
      : baseClient =
            BaseClient<Order>(fromJson: (json) => Order.fromJson(json));

  Future<ApiResponse<Order>> getOrders(
      {int page = 1, Map<String, dynamic>? queryParams}) async {
    try {
      var result = await baseClient.getAll(
          endpoint: OrderEndpoints.merchant,
          page: page,
          queryParams: queryParams);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<(Order?, String?)> changeOrderState({required String code}) async {
    try {
      final result = await baseClient.update(
        endpoint: OrderEndpoints.advanceStep(code),
      );
      return (result.singleData, result.message);
    } catch (e) {
      return (null, e.toString());
    }
  }

  Future<Order?>? getOrderByCode({required String code}) async {
    try {
      var result =
          await baseClient.getById(endpoint: OrderEndpoints.order, id: code);
      return result.singleData;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> validateCode({required String code}) async {
    try {
      final result = await BaseClient<bool>().get(
        endpoint: OrderEndpoints.available(code),
      );
      return result.singleData ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<(Order? order, String? error)> addOrder(
      {required AddOrderForm orderForm}) async {
    developer.log('🌐 OrdersService.addOrder() - بدء استدعاء API لإضافة طلب',
        name: 'OrdersService');

    try {
      // تحويل النموذج إلى JSON وتسجيل البيانات
      final jsonData = orderForm.toJson();
      developer.log('📤 البيانات المرسلة إلى API:', name: 'OrdersService');
      developer.log('  - Endpoint: ${OrderEndpoints.order}',
          name: 'OrdersService');
      developer.log('  - JSON Data: $jsonData', name: 'OrdersService');

      developer.log('🔄 استدعاء baseClient.create()...', name: 'OrdersService');
      var result = await baseClient.create(
          endpoint: OrderEndpoints.order, data: jsonData);

      developer.log('📥 استجابة API:', name: 'OrdersService');
      developer.log('  - Single Data: ${result.singleData?.code ?? "null"}',
          name: 'OrdersService');
      developer.log('  - Message: ${result.message ?? "null"}',
          name: 'OrdersService');
      developer.log('  - Success: ${result.singleData != null}',
          name: 'OrdersService');

      if (result.singleData == null) {
        developer.log('❌ فشل في إنشاء الطلب في الخدمة: ${result.message}',
            name: 'OrdersService');
        return (null, result.message);
      }

      developer.log(
          '✅ تم إنشاء الطلب بنجاح في الخدمة - كود الطلب: ${result.singleData!.code}',
          name: 'OrdersService');
      return (result.singleData, null);
    } catch (e) {
      developer.log('💥 خطأ في OrdersService.addOrder(): $e',
          name: 'OrdersService');
      rethrow;
    }
  }
}
