import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:Tosell/core/config/constants/spaces.dart';

class LoginSpacing {
  static Widget topGap() => const Gap(AppSpaces.small);

  static Widget formGap() => const Gap(AppSpaces.small);

  static Widget buttonTopGap(bool isTextFieldFocused) {
    return Gap(isTextFieldFocused ? AppSpaces.medium : AppSpaces.large);
  }

  static Widget buttonBottomGap(bool isTextFieldFocused) {
    return Gap(isTextFieldFocused ? AppSpaces.xxs : AppSpaces.small);
  }
}
