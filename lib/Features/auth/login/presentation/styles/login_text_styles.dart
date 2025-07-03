import 'package:flutter/material.dart';

class LoginTextStyles {
  static TextStyle welcomeTitle(BuildContext context) => const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 32,
        color: Color(0xFFFFFFFF), // White color for light theme
      );

  static TextStyle welcomeSubtitle(BuildContext context) => const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 16,
        color: Color(0xFFFFFFFF), // White color for light theme
      );

  static TextStyle appBarTitle(BuildContext context) => const TextStyle(
        fontWeight: FontWeight.w600,
        color: Color(0xFFFFFFFF), // White color for light theme
        fontSize: 16,
        fontFamily: "Tajawal",
      );

  static TextStyle noAccountText(BuildContext context) => const TextStyle(
        color: Color(0xFF698596), // Secondary color from light theme
      );

  static TextStyle createAccountText(BuildContext context) => const TextStyle(
        color: Color(0xFF16CA8B), // Primary color from light theme
        fontWeight: FontWeight.bold,
      );
}
