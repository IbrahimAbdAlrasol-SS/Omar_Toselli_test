import 'package:flutter/material.dart';
import 'package:Tosell/features/profile/data/models/zone.dart';

class RegistrationStateManager {
  String? fullName;
  String? brandName;
  String? userName;
  String? phoneNumber;
  String? password;
  String? brandImg;
  List<Zone> selectedZones = [];
  double? latitude;
  double? longitude;
  String? nearestLandmark;
  bool isSubmitting = false;
  bool canNavigateToSecondTab = false;
  int currentIndex = 0;
  
  void updateUserInfo({
    String? fullName,
    String? brandName,
    String? userName,
    String? phoneNumber,
    String? password,
    String? brandImg,
  }) {
    if (fullName != null) this.fullName = fullName;
    if (brandName != null) this.brandName = brandName;
    if (userName != null) this.userName = userName;
    if (phoneNumber != null) this.phoneNumber = phoneNumber;
    if (password != null) this.password = password;
    if (brandImg != null) this.brandImg = brandImg;
  }
}