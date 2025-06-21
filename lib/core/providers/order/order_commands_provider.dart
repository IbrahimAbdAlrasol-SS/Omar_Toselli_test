import 'dart:async';
import 'package:Tosell/core/Model/order/orders/Order.dart';
import 'package:Tosell/core/Services/order/orders_service.dart';
import 'package:Tosell/core/Model/order/Location.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:Tosell/core/Model/order/add_order_form.dart';
import 'dart:developer' as developer;

part 'order_commands_provider.g.dart';

@riverpod
class OrderCommandsNotifier extends _$OrderCommandsNotifier {
  final OrdersService _service = OrdersService();

  Future<(Order?, String?)> changeOrderState({required String code}) async {
    return (await _service.changeOrderState(code: code));
  }

  Future<(Order? order, String? error)> addOrder(AddOrderForm form) async {
    developer.log(
        '🚀 OrderCommandsNotifier.addOrder() - بدء عملية إضافة طلب جديد',
        name: 'OrderCommands');
    developer.log('📝 Form Data Received:', name: 'OrderCommands');
    developer.log('  - Customer Name: ${form.customerName}',
        name: 'OrderCommands');
    developer.log('  - Customer Phone: ${form.customerPhoneNumber}',
        name: 'OrderCommands');
    developer.log('  - Delivery Zone ID: ${form.deliveryZoneId}',
        name: 'OrderCommands');
    developer.log('  - Pickup Zone ID: ${form.pickupZoneId}',
        name: 'OrderCommands');
    developer.log('  - Content: ${form.content}', name: 'OrderCommands');
    developer.log('  - Amount: ${form.amount}', name: 'OrderCommands');

    // Set the state to loading before starting the async operation
    developer.log('⏳ تعيين حالة التحميل...', name: 'OrderCommands');
    state = const AsyncValue.loading();

    try {
      developer.log('🔄 استدعاء خدمة إضافة الطلب...', name: 'OrderCommands');
      // Perform the API call to add the order
      var result = await _service.addOrder(orderForm: form);

      developer.log('📡 استجابة الخدمة:', name: 'OrderCommands');
      developer.log('  - Order: ${result.$1?.code ?? "null"}',
          name: 'OrderCommands');
      developer.log('  - Error: ${result.$2 ?? "null"}', name: 'OrderCommands');

      // Update the state with the result if successful
      state = const AsyncValue.data([]);

      if (result.$1 == null) {
        developer.log('❌ فشل في إنشاء الطلب: ${result.$2}',
            name: 'OrderCommands');
        return (null, result.$2);
      }

      developer.log('✅ تم إنشاء الطلب بنجاح - كود الطلب: ${result.$1!.code}',
          name: 'OrderCommands');
      return (result.$1, null); // success result
    } catch (e) {
      developer.log('💥 خطأ في OrderCommandsNotifier.addOrder(): $e',
          name: 'OrderCommands');
      // If there's an error, update the state with an error
      state = AsyncError(e, StackTrace.current);
      return (null, e.toString()); // return error
    }
  }

  Future<bool> validateCode({
    required String code,
  }) async {
    var result = await _service.validateCode(code: code);
    return result;
  }

  @override
  FutureOr<void> build() async {}
}

final getOrderByCodeProvider =
    FutureProvider.family<Order?, String>((ref, code) async {
  final service = OrdersService(); // or inject via ref if needed
  return service.getOrderByCode(code: code);
});

final changeOrderStateProvider =
    FutureProvider.family<Order?, String>((ref, code) async {
  try {
    final service = OrdersService(); // or inject via ref if needed
    return service.getOrderByCode(code: code);
  } catch (e) {
    return (null);
  }
});
