import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildBackground(
    {Widget? child, double height = 360, required BuildContext context}) {
  return Stack(
    children: [
      Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withOpacity(0.8),
            ],
            begin: Alignment.topCenter, // التدرج من الأعلى
            end: Alignment.bottomCenter, // إلى الأسفل
            stops: [0.0, 0.8], // توزيع التدرج (اختياري)
          ),
        ),
      ),
      buildCircle(
        top: -180,
        right: -180,
        context: context,
      ),
      buildCircle(
        top: 200,
        left: -180,
        context: context,
      ),
      if (child != null) child
    ],
  );
}

Positioned buildCircle({
  double? bottom,
  double? left,
  double? right,
  double? top,
  double? circleWidth = 400,
  double? circleHeight = 320,
  required BuildContext context,
  bool isFirstCircle = true, // إضافة معامل لتحديد اللون
}) {
  return Positioned(
    bottom: bottom,
    left: left,
    right: right,
    top: top,
    child: Container(
      width: circleWidth,
      height: circleHeight,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isFirstCircle
            ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.1)
            : Theme.of(context).colorScheme.onPrimary.withOpacity(0.15),
      ),
    ),
  );
}
