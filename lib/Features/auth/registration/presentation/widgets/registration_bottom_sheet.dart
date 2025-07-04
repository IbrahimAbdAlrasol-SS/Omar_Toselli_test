
// lib/Features/auth/registration/presentation/widgets/registration_bottom_sheet.dart
import 'package:Tosell/Features/auth/registration/presentation/constants/registration_assets.dart';
import 'package:flutter/material.dart';
import '../constants/registration_dimensions.dart';

class RegistrationBottomSheet extends StatelessWidget {
  final Widget child;
  final ScrollController scrollController;

  const RegistrationBottomSheet({
    super.key,
    required this.child,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFBFAFF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(RegistrationDimensions.sheetBorderRadius),
          topRight: Radius.circular(RegistrationDimensions.sheetBorderRadius),
        ),
      ),
      child: child,
    );
  }
}