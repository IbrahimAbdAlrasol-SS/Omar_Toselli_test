
// lib/Features/auth/registration/presentation/controllers/tab_controller.dart
import 'package:flutter/material.dart';

class RegistrationTabController {
  final TabController tabController;
  final Function(int) onTabChanged;
  bool canNavigateToSecondTab = false;

  RegistrationTabController({
    required this.tabController,
    required this.onTabChanged,
  }) {
    _initialize();
  }

  void _initialize() {
    tabController.addListener(() {
      if (tabController.index == 1 && !canNavigateToSecondTab) {
        tabController.animateTo(0);
        return;
      }
      onTabChanged(tabController.index);
    });
  }

  void allowSecondTab() {
    canNavigateToSecondTab = true;
  }

  void goToTab(int index) {
    if (index == 1) {
      allowSecondTab();
    }
    tabController.animateTo(index);
  }

  void goToNextTab() {
    if (tabController.index < tabController.length - 1) {
      goToTab(tabController.index + 1);
    }
  }

  void goToPreviousTab() {
    if (tabController.index > 0) {
      tabController.animateTo(tabController.index - 1);
    }
  }

  void resetToFirstTab() {
    canNavigateToSecondTab = false;
    tabController.animateTo(0);
  }

  void dispose() {
    tabController.dispose();
  }
}