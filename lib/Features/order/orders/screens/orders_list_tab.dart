import 'package:Tosell/core/Model/order/orders/Order.dart';
import 'package:Tosell/core/Model/order/orders/OrderFilter.dart';
import 'package:Tosell/Features/order/orders/widgets/order_card_item.dart';
import 'package:Tosell/core/providers/order/orders_provider.dart';
import 'package:Tosell/core/providers/order/shipments_provider.dart';
import 'package:Tosell/paging/generic_paged_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Tosell/core/constants/spaces.dart';
import 'package:Tosell/core/utils/extensions.dart';
import 'package:Tosell/core/router/app_router.dart';
import 'package:Tosell/core/widgets/CustomTextFormField.dart';
import 'package:Tosell/core/widgets/FillButton.dart';
import 'package:Tosell/core/Model/order/orders/Shipment.dart';
import 'dart:developer' as developer;
import 'package:Tosell/paging/generic_paged_list_view.dart';

class OrdersListTab extends ConsumerStatefulWidget {
  final FetchPage<Order> fetchPage;
  final OrderFilter? filter;
  const OrdersListTab({super.key, this.filter, required this.fetchPage});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrdersListTabState();
}

class _OrdersListTabState extends ConsumerState<OrdersListTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool _isMultiSelectMode = false;
  final Set<String> _selectedOrderIds = {};
  List<Order> _allOrders = [];

  void _toggleMultiSelectMode() {
    setState(() {
      _isMultiSelectMode = !_isMultiSelectMode;
      if (!_isMultiSelectMode) {
        _selectedOrderIds.clear();
      }
    });
  }

  void _toggleOrderSelection(String orderId) {
    setState(() {
      if (_selectedOrderIds.contains(orderId)) {
        _selectedOrderIds.remove(orderId);
      } else {
        _selectedOrderIds.add(orderId);
      }
    });
  }

  void _selectAll() {
    setState(() {
      _selectedOrderIds.clear();
      for (var order in _allOrders) {
        if (order.id != null && order.status != null) {
          _selectedOrderIds.add(order.id!);
        }
      }
    });
  }

  void _clearAll() {
    setState(() {
      _selectedOrderIds.clear();
    });
  }

  void _createShipment() async {
    developer.log('🚀 بدء عملية إنشاء شحنة جديدة', name: 'CreateShipment');
    developer.log('📋 عدد الطلبات المحددة: ${_selectedOrderIds.length}',
        name: 'CreateShipment');
    developer.log('📋 معرفات الطلبات المحددة: $_selectedOrderIds',
        name: 'CreateShipment');

    if (_selectedOrderIds.isEmpty) {
      developer.log('❌ لا توجد طلبات محددة لإنشاء الشحنة',
          name: 'CreateShipment');
      _showMessage('يرجى تحديد طلبات لإنشاء الشحنة', Colors.orange);
      return;
    }

    developer.log('🔍 بدء فلترة الطلبات المتاحة للشحن...',
        name: 'CreateShipment');
    final availableOrderIds = <String>[];
    final unavailableOrderIds = <String>[];

    final ordersState = ref.read(ordersNotifierProvider);
    final currentOrders = ordersState.value ?? [];
    developer.log('📦 إجمالي الطلبات المحملة: ${currentOrders.length}',
        name: 'CreateShipment');

    for (String orderId in _selectedOrderIds) {
      try {
        final order = currentOrders.where((order) => order.id == orderId).first;
        developer.log(
            '🔎 فحص الطلب: ID=$orderId, Status=${order.status}, Code=${order.code}',
            name: 'CreateShipment');

        if (order.status != null && order.status! >= 0 && order.status! <= 17) {
          availableOrderIds.add(orderId);
          developer.log('✅ الطلب متاح للشحن: ${order.code}',
              name: 'CreateShipment');
        } else {
          unavailableOrderIds.add(orderId);
          developer.log(
              '❌ الطلب غير متاح للشحن: ${order.code} (Status: ${order.status})',
              name: 'CreateShipment');
        }
      } catch (e) {
        unavailableOrderIds.add(orderId);
        developer.log('⚠️ لم يتم العثور على الطلب: $orderId - $e',
            name: 'CreateShipment');
      }
    }

    developer.log('📊 نتائج الفلترة:', name: 'CreateShipment');
    developer.log('  - طلبات متاحة: ${availableOrderIds.length}',
        name: 'CreateShipment');
    developer.log('  - طلبات غير متاحة: ${unavailableOrderIds.length}',
        name: 'CreateShipment');

    if (availableOrderIds.isEmpty) {
      developer.log('❌ لا توجد طلبات متاحة للشحن', name: 'CreateShipment');
      _showMessage(
          'جميع الطلبات المحددة غير متاحة للشحن.\nيمكن شحن الطلبات في الحالات من 0 إلى 17 فقط.',
          Colors.orange);
      return;
    }

    if (unavailableOrderIds.isNotEmpty) {
      developer.log('⚠️ تم استبعاد ${unavailableOrderIds.length} طلب غير متاح',
          name: 'CreateShipment');
      _showMessage(
          'تم استبعاد ${unavailableOrderIds.length} طلب غير متاح للشحن',
          Colors.orange);
    }

    // تحضير البيانات - إرسال قائمة معرفات الطلبات فقط
    developer.log('📋 تحضير بيانات الشحنة...', name: 'CreateShipment');
    developer.log('📦 قائمة معرفات الطلبات للشحنة: $availableOrderIds',
        name: 'CreateShipment');

    final shipmentData = availableOrderIds;
    developer.log('📤 بيانات الشحنة المرسلة: $shipmentData',
        name: 'CreateShipment');

    // إرسال الطلب
    developer.log('🚀 إرسال طلب إنشاء الشحنة إلى الخادم...',
        name: 'CreateShipment');
    final result = await ref
        .read(shipmentsNotifierProvider.notifier)
        .createShipment(shipmentData: shipmentData, formType: 'pickup');

    developer.log('📥 استلام نتيجة إنشاء الشحنة:', name: 'CreateShipment');
    developer.log('  - نجح الإنشاء: ${result.$1 != null}',
        name: 'CreateShipment');
    developer.log('  - رسالة الخطأ: ${result.$2 ?? "لا يوجد"}',
        name: 'CreateShipment');

    if (result.$1 != null) {
      developer.log('✅ تم إنشاء الشحنة بنجاح', name: 'CreateShipment');
      developer.log('  - رقم الشحنة: ${result.$1!.code}',
          name: 'CreateShipment');
      developer.log('  - معرف الشحنة: ${result.$1!.id}',
          name: 'CreateShipment');
      developer.log('  - عدد الطلبات: ${availableOrderIds.length}',
          name: 'CreateShipment');
      _showMessage('تم إنشاء الشحنة بنجاح (${availableOrderIds.length} طلب)',
          Colors.green);
      _resetSelection();
    } else {
      // معالجة أنواع الأخطاء المختلفة
      String errorMessage = result.$2 ?? 'فشل في إنشاء الشحنة';
      developer.log('❌ فشل في إنشاء الشحنة: $errorMessage',
          name: 'CreateShipment');

      if (errorMessage.contains('Order already in shipment') ||
          errorMessage.contains('Order already in another Pickup shipment')) {
        developer.log('⚠️ خطأ: طلبات موجودة بالفعل في شحنة أخرى',
            name: 'CreateShipment');
        errorMessage =
            'بعض الطلبات المحددة موجودة بالفعل في شحنة أخرى غير مكتملة.\nيرجى اختيار طلبات أخرى أو التحقق من حالة الطلبات.';
      } else if (errorMessage.contains('400')) {
        developer.log('⚠️ خطأ 400: بيانات غير صحيحة', name: 'CreateShipment');
        errorMessage = 'خطأ في البيانات المرسلة. يرجى المحاولة مرة أخرى.';
      }

      _showMessage(errorMessage, Colors.red);
    }
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  void _resetSelection() {
    setState(() {
      _selectedOrderIds.clear();
      _isMultiSelectMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: Column(
        children: [
          // Multi-select header
          if (_isMultiSelectMode)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                border: Border(
                  bottom: BorderSide(
                    color:
                        Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Select all button
                  GestureDetector(
                    onTap: _selectAll,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/svg/CheckSquare.svg',
                            width: 16,
                            height: 16,
                            color: Colors.white,
                          ),
                          const Gap(AppSpaces.exSmall),
                          Text(
                            'تحديد الكل',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(AppSpaces.small),
                  // Clear all button
                  GestureDetector(
                    onTap: _clearAll,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/svg/x.svg',
                            width: 16,
                            height: 16,
                            color: Colors.white,
                          ),
                          const Gap(AppSpaces.exSmall),
                          Text(
                            'إلغاء الكل',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Selected count
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    child: Text(
                      'محدد: ${_selectedOrderIds.length}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          // Orders list
          Expanded(
            child: GenericPagedListView<Order>(
              itemBuilder: (context, order, index) {
                // Update all orders list for select all functionality
                if (!_allOrders.any((o) => o.id == order.id)) {
                  _allOrders.add(order);
                }

                return OrderCardItem(
                  order: order,
                  isMultiSelectMode: _isMultiSelectMode,
                  isSelected: _selectedOrderIds.contains(order.id),
                  onSelectionToggle: () =>
                      _toggleOrderSelection(order.id ?? ''),
                  onTap: () {
                    if (!_isMultiSelectMode) {
                      context.push(AppRoutes.orderDetails, extra: order.code);
                    }
                  },
                );
              },
              fetchPage: (page, filter) async {
                final result = await widget.fetchPage(page);
                if (result.data != null) {
                  for (var order in result.data!) {
                    if (!_allOrders.any((o) => o.id == order.id)) {
                      _allOrders.add(order);
                    }
                  }
                }
                return result;
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // زر إرسال الشحنة (يظهر فقط في وضع التحديد المتعدد)
          if (_isMultiSelectMode && _selectedOrderIds.isNotEmpty)
            FloatingActionButton.extended(
              onPressed: _createShipment,
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              elevation: 8,
              icon: SvgPicture.asset(
                'assets/svg/Truck.svg',
                width: 20,
                height: 20,
                color: Colors.white,
              ),
              label: Text(
                'إرسال شحنة (${_selectedOrderIds.length})',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (_isMultiSelectMode && _selectedOrderIds.isNotEmpty)
            const Gap(AppSpaces.small),
          // زر التحديد المتعدد
          FloatingActionButton(
            onPressed: _toggleMultiSelectMode,
            backgroundColor: _isMultiSelectMode
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            elevation: 8,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _isMultiSelectMode
                  ? const Icon(
                      Icons.close,
                      key: ValueKey('close'),
                    )
                  : SvgPicture.asset(
                      'assets/svg/CheckSquare.svg',
                      key: const ValueKey('select'),
                      width: 24,
                      height: 24,
                      color: Colors.white,
                    ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
