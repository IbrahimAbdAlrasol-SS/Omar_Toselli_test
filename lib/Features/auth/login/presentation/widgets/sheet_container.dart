import 'package:flutter/material.dart';
import '../constants/login_dimensions.dart';

class SheetContainer extends StatelessWidget {
  final Widget child;

  const SheetContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: LoginDimensions.horizontalPadding,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFFBFAFF), // Light theme surface color
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(LoginDimensions.sheetBorderRadius),
          topRight: Radius.circular(LoginDimensions.sheetBorderRadius),
        ),
      ),
      child: child,
    );
  }
}
