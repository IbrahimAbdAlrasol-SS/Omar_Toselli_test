import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/login_dimensions.dart';
import 'sheet_container.dart';
import 'sheet_content.dart';

class LoginFormSheet extends ConsumerWidget {
  final DraggableScrollableController scrollableController;
  final GlobalKey<FormState> formKey;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final FocusNode phoneFocusNode;
  final FocusNode passwordFocusNode;
  final bool isTextFieldFocused;
  final bool isPasswordVisible;
  final VoidCallback onPasswordVisibilityToggle;
  final AsyncValue<void> loginState;

  const LoginFormSheet({
    super.key,
    required this.scrollableController,
    required this.formKey,
    required this.phoneController,
    required this.passwordController,
    required this.phoneFocusNode,
    required this.passwordFocusNode,
    required this.isTextFieldFocused,
    required this.isPasswordVisible,
    required this.onPasswordVisibilityToggle,
    required this.loginState,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DraggableScrollableSheet(
      controller: scrollableController,
      initialChildSize: LoginDimensions.initialSheetSize,
      minChildSize: LoginDimensions.minSheetSize,
      maxChildSize: LoginDimensions.maxSheetSize,
      builder: (context, scrollController) {
        return SheetContainer(
           child: SheetContent(
             formKey: formKey,
             phoneController: phoneController,
             passwordController: passwordController,
             phoneFocusNode: phoneFocusNode,
             passwordFocusNode: passwordFocusNode,
             isPasswordVisible: isPasswordVisible,
             onPasswordVisibilityToggle: onPasswordVisibilityToggle,
             isTextFieldFocused: isTextFieldFocused,
             loginState: loginState,
             ref: ref,
           ),
         );
      },
    );
  }
}