import 'package:flutter/material.dart';

class OrderEnum {
  String? name;
  Color? textColor;
  Color? darkTextColor;
  String? icon;
  Color? iconColor;
  Color? darkIconColor;
  Color? color;
  Color? darkColor;
  String? description;
  int? value;

  OrderEnum({
    this.name,
    this.icon,
    this.color,
    this.darkColor,
    this.value,
    this.description,
    this.iconColor,
    this.darkIconColor,
    this.textColor,
    this.darkTextColor,
  });

  // Helper methods to get colors based on theme
  Color getBackgroundColor(bool isDark) {
    return isDark
        ? (darkColor ?? color ?? Colors.grey)
        : (color ?? Colors.grey);
  }

  Color getTextColor(bool isDark, Color fallbackColor) {
    if (isDark) {
      return darkTextColor ?? textColor ?? fallbackColor;
    }
    return textColor ?? fallbackColor;
  }

  Color getIconColor(bool isDark, Color fallbackColor) {
    if (isDark) {
      return darkIconColor ?? iconColor ?? fallbackColor;
    }
    return iconColor ?? fallbackColor;
  }
}

var orderStatus = [
  //? index = 0
  OrderEnum(
      name: 'في الانتطار',
      color: const Color(0xFFE8FCF5),
      darkColor: const Color(0xFF1A4A3A),
      iconColor: Colors.black,
      darkIconColor: const Color(0xFF16CA8B),
      textColor: const Color(0xFF16CA8B),
      darkTextColor: const Color(0xFF16CA8B),
      icon: 'assets/svg/box.svg',
      description: 'طلبك قيد انتظار الموافقة',
      value: 0),
  //? index = 1
  OrderEnum(
      name: 'قائمة استحصال',
      color: const Color(0xFFE5F6FF),
      darkColor: const Color(0xFF1A3A4A),
      iconColor: Colors.black,
      darkIconColor: const Color(0xFF3B82F6),
      textColor: Colors.black,
      darkTextColor: const Color(0xFF3B82F6),
      icon: 'assets/svg/box.svg',
      description: 'في قائمة الاستحصال',
      value: 1),
  //? index = 2
  OrderEnum(
      name: 'قيد الاستحصال',
      color: const Color(0xFFE8FCF5),
      darkColor: const Color(0xFF1A4A3A),
      iconColor: Colors.black,
      darkIconColor: const Color(0xFF16CA8B),
      textColor: Colors.black,
      darkTextColor: const Color(0xFF16CA8B),
      icon: 'assets/svg/box.svg',
      description: ' طلبك قيد الاستحصال من قبل المندوب',
      value: 2),
  //? index = 3 - AtPickUpPoint
  OrderEnum(
      name: 'في نقطة الاستحصال',
      color: const Color(0xFFE8FCF5),
      darkColor: const Color(0xFF1A4A3A),
      iconColor: Colors.black,
      darkIconColor: const Color(0xFF16CA8B),
      textColor: Colors.black,
      darkTextColor: const Color(0xFF16CA8B),
      icon: 'assets/svg/box.svg',
      description: 'الطلب في نقطة الاستحصال',
      value: 3),
  //? index = 4 - Received
  OrderEnum(
      name: 'تم الاستحصال',
      color: const Color(0xFFE8FCF5),
      darkColor: const Color(0xFF1A4A3A),
      iconColor: Colors.black,
      darkIconColor: const Color(0xFF16CA8B),
      textColor: Colors.black,
      darkTextColor: const Color(0xFF16CA8B),
      icon: 'assets/svg/box.svg',
      description: 'تم استحصال الطلب من قبل المندوب',
      value: 4),
  //? index = 5 - NotReceived
  OrderEnum(
      name: 'غير مستحصل',
      color: const Color(0xFFFFF3E0),
      darkColor: const Color(0xFF4A3A1A),
      iconColor: Colors.orange,
      darkIconColor: const Color(0xFFF59E0B),
      textColor: Colors.orange,
      darkTextColor: const Color(0xFFF59E0B),
      icon: 'assets/svg/box.svg',
      description: 'لم يتم استحصال الطلب من قبل المندوب',
      value: 5),
  //? index = 6 - OnTheWay
  OrderEnum(
      name: 'في الطريق',
      color: const Color(0xFFE8FCF5),
      darkColor: const Color(0xFF1A4A3A),
      iconColor: Colors.black,
      darkIconColor: const Color(0xFF16CA8B),
      textColor: Colors.black,
      darkTextColor: const Color(0xFF16CA8B),
      icon: 'assets/svg/box.svg',
      description: 'الطلب في الطريق إليك',
      value: 6),
  //? index = 7 - Delivered
  OrderEnum(
      name: 'تم التوصيل',
      color: const Color(0xFFE8FCF5),
      darkColor: const Color(0xFF1A4A3A),
      iconColor: Colors.black,
      darkIconColor: const Color(0xFF16CA8B),
      textColor: Colors.black,
      darkTextColor: const Color(0xFF16CA8B),
      icon: 'assets/svg/box.svg',
      description: 'تم توصيل الطلب بنجاح',
      value: 7),
  //? index = 8 - NotDelivered
  OrderEnum(
      name: 'غير موصل',
      color: const Color(0xFFFFF3E0),
      darkColor: const Color(0xFF4A3A1A),
      iconColor: Colors.orange,
      darkIconColor: const Color(0xFFF59E0B),
      textColor: Colors.orange,
      darkTextColor: const Color(0xFFF59E0B),
      icon: 'assets/svg/box.svg',
      description: 'لم يتم توصيل الطلب',
      value: 8),
  //? index = 9 - AtDeliveryPoint
  OrderEnum(
      name: 'في نقطة التوصيل',
      color: const Color(0xFFE8FCF5),
      darkColor: const Color(0xFF1A4A3A),
      iconColor: Colors.black,
      darkIconColor: const Color(0xFF16CA8B),
      textColor: Colors.black,
      darkTextColor: const Color(0xFF16CA8B),
      icon: 'assets/svg/box.svg',
      description: 'الطلب في نقطة التوصيل',
      value: 9),
  //? index = 10 - Delivered
  OrderEnum(
      name: 'تم التوصيل',
      color: const Color(0xFFE8FCF5),
      darkColor: const Color(0xFF1A4A3A),
      iconColor: Colors.black,
      darkIconColor: const Color(0xFF16CA8B),
      textColor: Colors.black,
      darkTextColor: const Color(0xFF16CA8B),
      icon: 'assets/svg/box.svg',
      description: 'تم توصيل الطلب بنجاح',
      value: 10),
  //? index = 11 - NotDelivered
  OrderEnum(
      name: 'غير موصل',
      color: const Color(0xFFFFF3E0),
      darkColor: const Color(0xFF4A3A1A),
      iconColor: Colors.orange,
      darkIconColor: const Color(0xFFF59E0B),
      textColor: Colors.orange,
      darkTextColor: const Color(0xFFF59E0B),
      icon: 'assets/svg/box.svg',
      description: 'لم يتم توصيل الطلب',
      value: 11),
  //? index = 12 - Cancelled
  OrderEnum(
      name: 'ملغي',
      color: const Color(0xFFF3E5F5),
      darkColor: const Color(0xFF4A1A4A),
      iconColor: Colors.purple,
      darkIconColor: const Color(0xFFA855F7),
      textColor: Colors.purple,
      darkTextColor: const Color(0xFFA855F7),
      icon: 'assets/svg/box.svg',
      description: 'تم إلغاء الطلب',
      value: 12),
  //? index = 13 - Rescheduled
  OrderEnum(
      name: 'مؤجل',
      color: const Color(0xFFFFF3E0),
      darkColor: const Color(0xFF4A3A1A),
      iconColor: Colors.orange,
      darkIconColor: const Color(0xFFF59E0B),
      textColor: Colors.orange,
      darkTextColor: const Color(0xFFF59E0B),
      icon: 'assets/svg/box.svg',
      description: 'تم تأجيل الطلب',
      value: 13),
  //? index = 14 - Refunded
  OrderEnum(
      name: 'مسترجع',
      color: const Color(0xFFF3E5F5),
      darkColor: const Color(0xFF4A1A4A),
      iconColor: Colors.purple,
      darkIconColor: const Color(0xFFA855F7),
      textColor: Colors.purple,
      darkTextColor: const Color(0xFFA855F7),
      icon: 'assets/svg/box.svg',
      description: 'تم استرجاع الطلب',
      value: 14),
  //? index = 15 - RescheduledDelegate
  OrderEnum(
      name: 'مؤجل مندوب',
      color: const Color(0xFFFFF3E0),
      iconColor: Colors.orange,
      textColor: Colors.orange,
      icon: 'assets/svg/box.svg',
      description: 'تم تأجيل الطلب من قبل المندوب',
      value: 15),
  //? index = 16 - RefundedInWarehouse
  OrderEnum(
      name: 'مسترد في المستودع',
      color: const Color(0xFFF3E5F5),
      iconColor: Colors.purple,
      textColor: Colors.purple,
      icon: 'assets/svg/box.svg',
      description: 'تم استرداد الطلب في المستودع',
      value: 16),
  //? index = 17 - RefundedDelegate
  OrderEnum(
      name: 'مسترد مندوب',
      color: const Color(0xFFF3E5F5),
      iconColor: Colors.purple,
      textColor: Colors.purple,
      icon: 'assets/svg/box.svg',
      description: 'تم استرداد الطلب من قبل المندوب',
      value: 17),
//? Order Status Values:
//? 0-  Pending - في الانتظار
//? 1-  InPickUpShipment - في شحنة الاستحصال
//? 2-  InPickUpProgress - قيد الاستحصال
//? 3-  AtPickUpPoint - في نقطة الاستحصال
//? 4-  Received - تم الاستلام
//? 5-  NotReceived - لم يتم الاستلام
//? 6-  InWarehouse - في المخزن
//? 7-  InDeliveryShipment - في شحنة التوصيل
//? 8-  InDeliveryProgress - قيد التوصيل
//? 9-  AtDeliveryPoint - في نقطة التوصيل
//? 10- Delivered - تم التوصيل
//? 11- PartiallyDelivered - توصيل جزئي
//? 12- Cancelled - ملغي
//? 13- Completed - مكتمل
//? 14- RescheduledInWarehouse - مؤجل في المستودع
//? 15- RescheduledDelegate - مؤجل مندوب
//? 16- RefundedInWarehouse - مسترد في المستودع
//? 17- RefundedDelegate - مسترد مندوب
];

// ignore: unused_element

class OrderSizeEnum {
  String? name;

  int? value;

  OrderSizeEnum({
    this.name,
    this.value,
  });
}

var orderSizes = [
  OrderSizeEnum(name: 'صغير', value: 0),
  OrderSizeEnum(name: 'متوسط', value: 1),
  OrderSizeEnum(name: 'كبير', value: 2),
];
