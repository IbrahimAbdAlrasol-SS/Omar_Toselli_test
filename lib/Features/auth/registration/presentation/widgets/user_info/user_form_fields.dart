// lib/Features/auth/registration/presentation/widgets/user_info/user_form_fields.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:Tosell/core/widgets/inputs/CustomTextFormField.dart';
import '../../constants/registration_assets.dart';
import '../../constants/registration_dimensions.dart';
import '../../constants/registration_strings.dart';
import '../../validators/user_info_validators.dart';

class UserFormFields extends StatelessWidget {
  final TextEditingController fullNameController;
  final TextEditingController brandNameController;
  final TextEditingController userNameController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  
  final FocusNode fullNameFocus;
  final FocusNode brandNameFocus;
  final FocusNode userNameFocus;
  final FocusNode phoneFocus;
  final FocusNode passwordFocus;
  final FocusNode confirmPasswordFocus;
  
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;
  final Function(String) onFieldChanged;

  const UserFormFields({
    super.key,
    required this.fullNameController,
    required this.brandNameController,
    required this.userNameController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.fullNameFocus,
    required this.brandNameFocus,
    required this.userNameFocus,
    required this.phoneFocus,
    required this.passwordFocus,
    required this.confirmPasswordFocus,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
    required this.onFieldChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFullNameField(),
        const Gap(RegistrationDimensions.fieldGap),
        _buildBrandNameField(),
        const Gap(RegistrationDimensions.fieldGap),
        _buildUserNameField(),
        const Gap(RegistrationDimensions.fieldGap),
        _buildPhoneField(),
        const Gap(RegistrationDimensions.fieldGap),
        _buildPasswordFields(),
      ],
    );
  }

  Widget _buildFullNameField() {
    return CustomTextFormField(
      controller: fullNameController,
      focusNode: fullNameFocus,
      label: RegistrationStrings.ownerName,
      hint: RegistrationStrings.ownerNameHint,
      prefixInner: _buildFieldIcon(RegistrationAssets.userIcon),
      validator: UserInfoValidators.validateOwnerName,
      onChanged: onFieldChanged,
      onFieldSubmitted: (_) => brandNameFocus.requestFocus(),
    );
  }

  Widget _buildBrandNameField() {
    return CustomTextFormField(
      controller: brandNameController,
      focusNode: brandNameFocus,
      label: RegistrationStrings.storeName,
      hint: RegistrationStrings.storeNameHint,
      prefixInner: _buildFieldIcon(RegistrationAssets.storeIcon),
      validator: UserInfoValidators.validateStoreName,
      onChanged: onFieldChanged,
      onFieldSubmitted: (_) => userNameFocus.requestFocus(),
    );
  }

  Widget _buildUserNameField() {
    return CustomTextFormField(
      controller: userNameController,
      focusNode: userNameFocus,
      label: RegistrationStrings.userName,
      hint: RegistrationStrings.userNameHint,
      prefixInner: _buildFieldIcon(RegistrationAssets.userIcon),
      validator: UserInfoValidators.validateUserName,
      onChanged: onFieldChanged,
      onFieldSubmitted: (_) => phoneFocus.requestFocus(),
    );
  }

  Widget _buildPhoneField() {
    return CustomTextFormField(
      controller: phoneController,
      focusNode: phoneFocus,
      label: RegistrationStrings.phoneNumber,
      hint: RegistrationStrings.phoneHint,
      keyboardType: TextInputType.phone,
      prefixInner: _buildFieldIcon(RegistrationAssets.phoneIcon),
      validator: UserInfoValidators.validatePhone,
      onChanged: onFieldChanged,
      onFieldSubmitted: (_) => passwordFocus.requestFocus(),
    );
  }

  Widget _buildPasswordFields() {
    return Column(
      children: [
        CustomTextFormField(
          controller: passwordController,
          focusNode: passwordFocus,
          label: RegistrationStrings.password,
          hint: RegistrationStrings.passwordHint,
          obscureText: obscurePassword,
          prefixInner: _buildFieldIcon(RegistrationAssets.passwordIcon),
          suffixInner: _buildPasswordToggle(obscurePassword, onTogglePassword),
          validator: UserInfoValidators.validatePassword,
          onChanged: onFieldChanged,
          onFieldSubmitted: (_) => confirmPasswordFocus.requestFocus(),
        ),
        const Gap(RegistrationDimensions.fieldGap),
        CustomTextFormField(
          controller: confirmPasswordController,
          focusNode: confirmPasswordFocus,
          label: RegistrationStrings.confirmPassword,
          hint: RegistrationStrings.confirmPasswordHint,
          obscureText: obscureConfirmPassword,
          prefixInner: _buildFieldIcon(RegistrationAssets.passwordIcon),
          suffixInner: _buildPasswordToggle(obscureConfirmPassword, onToggleConfirmPassword),
          validator: (value) => UserInfoValidators.validateConfirmPassword(
            value, 
            passwordController.text,
          ),
          onChanged: onFieldChanged,
        ),
      ],
    );
  }

  Widget _buildFieldIcon(String assetPath) {
    return Padding(
      padding: const EdgeInsets.all(RegistrationDimensions.iconPadding),
      child: SvgPicture.asset(
        assetPath,
        color: const Color(0xFF16CA8B),
      ),
    );
  }

  Widget _buildPasswordToggle(bool isObscured, VoidCallback onToggle) {
    return Padding(
      padding: const EdgeInsets.all(RegistrationDimensions.iconPadding),
      child: GestureDetector(
        onTap: onToggle,
        child: SvgPicture.asset(
          isObscured ? RegistrationAssets.eyeSlashIcon : RegistrationAssets.eyeIcon,
          color: const Color(0xFF16CA8B),
        ),
      ),
    );
  }
}
