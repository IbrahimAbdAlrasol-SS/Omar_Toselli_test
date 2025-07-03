import 'package:Tosell/core/config/routes/app_router.dart';
import 'package:Tosell/features/orders/data/models/OrderFilter.dart';
import 'package:Tosell/features/orders/data/models/Shipment.dart';
import 'package:Tosell/features/orders/presentation/widgets/shipment_cart_Item.dart';

import 'package:Tosell/paging/generic_paged_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Tosell/paging/generic_paged_list_view.dart';
class shipmentInfoTab extends ConsumerStatefulWidget {
  final FetchPage<Shipment> fetchPage;
  final OrderFilter? filter;
  const shipmentInfoTab({super.key, this.filter, required this.fetchPage});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _shipmentInfoTabState();
}

class _shipmentInfoTabState extends ConsumerState<shipmentInfoTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return GenericPagedListView<Shipment>(
      itemBuilder: (context, shipment, index) => ShipmentCartItem(
        shipment: shipment,
        onTap: () {
          // التنقل إلى شاشة تفاصيل الشحنة التي تعرض قائمة الطلبات
          context.push(AppRoutes.shipmentDetails, extra: shipment.code);
        },
      ),
      fetchPage: (page, filter) async {
        return await widget.fetchPage(page);
      },
    );
  }
}
