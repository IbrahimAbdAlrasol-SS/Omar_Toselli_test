import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../constants/login_assets.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(LoginAssets.logo);
  }
}