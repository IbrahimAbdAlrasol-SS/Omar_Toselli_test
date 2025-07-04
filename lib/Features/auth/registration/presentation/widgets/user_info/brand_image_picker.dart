
// lib/Features/auth/registration/presentation/widgets/user_info/brand_image_picker.dart
import 'package:Tosell/Features/auth/registration/presentation/constants/registration_assets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Tosell/core/widgets/inputs/CustomTextFormField.dart';
import '../../constants/registration_dimensions.dart';
import '../../constants/registration_strings.dart';
import '../../validators/user_info_validators.dart';

class BrandImagePicker extends StatelessWidget {
  final XFile? brandImage;
  final String? uploadedImageUrl;
  final bool isUploadingImage;
  final VoidCallback onPickImage;

  const BrandImagePicker({
    super.key,
    required this.brandImage,
    required this.uploadedImageUrl,
    required this.isUploadingImage,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      readOnly: true,
      label: RegistrationStrings.storeLogo,
      hint: _getHintText(),
      validator: (_) => UserInfoValidators.validateStoreImage(uploadedImageUrl),
      suffixInner: _buildUploadButton(context),
    );
  }

  String _getHintText() {
    if (brandImage != null) {
      return brandImage!.name;
    } else if (uploadedImageUrl != null) {
      return uploadedImageUrl!.split('/').last;
    }
    return "أضغط هنا";
  }

  Widget _buildUploadButton(BuildContext context) {
    return GestureDetector(
      onTap: isUploadingImage ? null : onPickImage,
      child: Container(
        width: RegistrationDimensions.imageUploadButtonWidth,
        height: RegistrationDimensions.imageUploadButtonHeight,
        decoration: BoxDecoration(
          color: isUploadingImage
              ? const Color(0xFFEAEEF0)
              : const Color(0xFF16CA8B),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(27),
            bottomLeft: Radius.circular(27),
          ),
        ),
        child: Center(
          child: isUploadingImage
              ? _buildLoadingIndicator()
              : _buildUploadText(),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 2,
      ),
    );
  }

  Widget _buildUploadText() {
    return const Text(
      RegistrationStrings.uploadImage,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontFamily: "Tajawal",
      ),
    );
  }
}