// lib/Features/auth/registration/presentation/styles/registration_text_styles.dart
import 'package:flutter/material.dart';

class RegistrationTextStyles {
  static TextStyle appBarTitle(BuildContext context) => const TextStyle(
        fontWeight: FontWeight.w600,
        color: Color(0xFFFFFFFF),
        fontSize: 16,
        fontFamily: "Tajawal",
      );

  static TextStyle welcomeTitle(BuildContext context) => const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 32,
        color: Colors.white,
      );

  static TextStyle welcomeSubtitle(BuildContext context) => const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 16,
        color: Colors.white,
      );

  static TextStyle tabTitle(BuildContext context, {required bool isSelected}) => TextStyle(
        color: isSelected
            ? const Color(0xFF16CA8B)
            : const Color(0xFF698596),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      );

  static TextStyle fieldLabel(BuildContext context) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: "Tajawal",
        color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle fieldHint(BuildContext context) => const TextStyle(
        color: Color(0xFF698596),
      );

  static TextStyle buttonText(BuildContext context) => const TextStyle(
        fontSize: 16,
        fontFamily: "Tajawal",
        color: Colors.white,
      );

  static TextStyle linkText(BuildContext context) => const TextStyle(
        color: Color(0xFF16CA8B),
        fontWeight: FontWeight.bold,
      );

  static TextStyle normalText(BuildContext context) => const TextStyle(
        color: Color(0xFF698596),
      );

  static TextStyle sectionTitle(BuildContext context) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: "Tajawal",
        color: const Color(0xFF1C1B1F),
      );

  static TextStyle zoneTypeText(BuildContext context, {required bool isCenter}) => TextStyle(
        fontSize: 12,
        color: isCenter
            ? const Color(0xFF16CA8B)
            : const Color(0xFF698596),
        fontFamily: "Tajawal",
      );
}