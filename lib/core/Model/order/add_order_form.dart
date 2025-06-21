import 'package:Tosell/core/Model/order/Location.dart';
import 'dart:developer' as developer;

class AddOrderForm {
  String? code;
  String? customerName;
  String? customerPhoneNumber;
  String? customerSecondPhoneNumber;
  String? deliveryZoneId;
  String? pickupZoneId;
  String? content;
  String? note;
  int? size;
  Location? pickUpLocation;
  String? amount;

  AddOrderForm({
    this.code,
    this.customerName,
    this.customerPhoneNumber,
    this.customerSecondPhoneNumber,
    this.deliveryZoneId,
    this.pickupZoneId,
    this.content,
    this.note,
    this.size,
    this.amount,
    this.pickUpLocation,
  });

  Map<String, dynamic> toJson() {
    developer.log('🔄 AddOrderForm.toJson() - بدء تحويل النموذج إلى JSON', name: 'AddOrderForm');
    
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['customerName'] = customerName;
    data['customerPhoneNumber'] = customerPhoneNumber;
    data['customerSecondPhoneNumber'] = customerSecondPhoneNumber;
    
    // نجرب 
    data['deliveryZoneId'] = deliveryZoneId ?? '412';
    data['pickupZoneId'] = pickupZoneId;
    
    data['content'] = content;
    data['note'] = note;
    data['size'] = size;
    data['pickUpLocation'] = pickUpLocation?.toJson();
    data['amount'] = amount;
    
    developer.log('📋 AddOrderForm JSON Data:', name: 'AddOrderForm');
    developer.log('  - Code: $code', name: 'AddOrderForm');
    developer.log('  - Customer Name: $customerName', name: 'AddOrderForm');
    developer.log('  - Customer Phone: $customerPhoneNumber', name: 'AddOrderForm');
    developer.log('  - Delivery Zone ID: ${data['deliveryZoneId']}', name: 'AddOrderForm');
    developer.log('  - Pickup Zone ID: ${data['pickupZoneId']}', name: 'AddOrderForm');
    developer.log('  - Content: $content', name: 'AddOrderForm');
    developer.log('  - Amount: $amount', name: 'AddOrderForm');
    developer.log('  - Size: $size', name: 'AddOrderForm');
    developer.log('  - Pickup Location: ${pickUpLocation?.toJson()}', name: 'AddOrderForm');
    
    developer.log('✅ AddOrderForm.toJson() - تم إنشاء JSON بنجاح', name: 'AddOrderForm');
    return data;
  }
}