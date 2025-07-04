
// lib/Features/auth/registration/presentation/widgets/registration_background.dart
import 'package:flutter/material.dart';
import 'package:Tosell/features/auth/registration/presentation/widgets/build_background.dart';

class RegistrationBackground extends StatelessWidget {
  final Widget child;

  const RegistrationBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: buildBackground(
        context: context,
        child: child,
      ),
    );
  }
}