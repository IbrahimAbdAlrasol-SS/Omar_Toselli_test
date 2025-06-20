import 'package:Tosell/core/Model/order/orders/Order.dart';
import 'package:Tosell/core/Client/BaseClient.dart';
import 'package:Tosell/core/Client/ApiResponse.dart';
import 'package:Tosell/core/Client/APIendpoint.dart';
import 'package:Tosell/core/Model/order/add_order_form.dart';

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
    try {
      var result = await baseClient.create(
          endpoint: OrderEndpoints.order, data: orderForm.toJson());
      if (result.singleData == null) return (null, result.message);

      return (result.singleData, null);
    } catch (e) {
      rethrow;
    }
  }
}
