import 'package:flutter/material.dart';
import '../constants/login_assets.dart';

class LoginShapeWidget extends StatelessWidget {
  final bool isVisible;

  const LoginShapeWidget({
    super.key,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();
    
    return Center(
      child: Image.asset(LoginAssets.shape),
    );
  }
}