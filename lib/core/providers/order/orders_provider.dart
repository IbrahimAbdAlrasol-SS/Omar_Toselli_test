// lib/core/providers/order/orders_provider.dart
import 'dart:async';
import 'package:Tosell/core/Model/order/orders/Order.dart';
import 'package:Tosell/core/Services/order/orders_service.dart';
import 'package:Tosell/core/Client/ApiResponse.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:Tosell/core/Model/order/add_order_form.dart';
import 'dart:developer' as developer;

part 'orders_provider.g.dart';

@riverpod
class OrdersNotifier extends _$OrdersNotifier {
  final OrdersService _service = OrdersService();
  
  Future<ApiResponse<Order>> getAll({
    int page = 1, 
    Map<String, dynamic>? queryParams
  }) async {
    try {
      return await _service.getOrders(queryParams: queryParams, page: page);
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse<Order>> getOrdersByShipment(
    String shipmentCode,
    int page,
  ) async {
    try {
      final queryParams = {'shipmentCode': shipmentCode};
      return await _service.getOrders(queryParams: queryParams, page: page);
    } catch (e) {
      rethrow;
    }
  }
  
  Future<Order?> getOrderByCode({required String code}) async {
    try {
      return await _service.getOrderByCode(code: code);
    } catch (e) {
      rethrow;
    }
  }
  
  Future<(Order? order, String? error)> addOrder(AddOrderForm form) async {
    developer.log('🚀 OrdersNotifier.addOrder() - بدء عملية إضافة طلب', name: 'OrdersProvider');
    
    try {
      developer.log('⏳ تعيين حالة التحميل في OrdersNotifier...', name: 'OrdersProvider');
      state = const AsyncValue.loading();
      
      developer.log('🔄 استدعاء خدمة الطلبات من OrdersNotifier...', name: 'OrdersProvider');
      var result = await _service.addOrder(orderForm: form);
      
      developer.log('📡 نتيجة الخدمة في OrdersNotifier:', name: 'OrdersProvider');
      developer.log('  - Order Created: ${result.$1 != null}', name: 'OrdersProvider');
      developer.log('  - Order Code: ${result.$1?.code ?? "N/A"}', name: 'OrdersProvider');
      developer.log('  - Error Message: ${result.$2 ?? "N/A"}', name: 'OrdersProvider');

      if (result.$1 != null) {
        developer.log('✅ تم إنشاء الطلب بنجاح، تحديث القائمة...', name: 'OrdersProvider');
        await refresh();
        return (result.$1, null);
      } else {
        developer.log('❌ فشل في إنشاء الطلب في OrdersNotifier: ${result.$2}', name: 'OrdersProvider');
        return (null, result.$2);
      }
    } catch (e) {
      developer.log('💥 خطأ في OrdersNotifier.addOrder(): $e', name: 'OrdersProvider');
      state = AsyncValue.error(e, StackTrace.current);
      return (null, e.toString());
    }
  }
  
  Future<bool> validateCode({required String code}) async {
    try {
      return await _service.validateCode(code: code);
    } catch (e) {
      return false;
    }
  }
  
  Future<void> refresh({Map<String, dynamic>? queryParams}) async {
    try {
      final hasData = state.hasValue && state.value!.isNotEmpty;
      
      if (!hasData) {
        state = const AsyncValue.loading();
      }
      final result = await getAll(page: 1, queryParams: queryParams);
      state = AsyncValue.data(result.data ?? []);
    } catch (e) {
      final currentData = state.valueOrNull;
      if (currentData == null || currentData.isEmpty) {
        state = AsyncValue.error(e, StackTrace.current);
      }
    }
  }
  
  Future<void> search(String searchTerm) async {
    try {
      state = const AsyncValue.loading();
      
      final queryParams = searchTerm.isNotEmpty 
          ? {'code': searchTerm}
          : <String, dynamic>{};
      final result = await getAll(page: 1, queryParams: queryParams);
      state = AsyncValue.data(result.data ?? []);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
  
  @override
  FutureOr<List<Order>> build() async {
    try {
      var result = await getAll();
      return result.data ?? [];
    } catch (e) {
      throw e;
    }
  }
}