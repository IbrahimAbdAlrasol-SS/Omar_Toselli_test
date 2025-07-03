import 'package:flutter/material.dart';
import '../state/registration_state_manager.dart';

class TabControllerHandler {
  static void setupTabController({
    required TabController tabController,
    required RegistrationStateManager stateManager,
    required VoidCallback onStateChanged,
  }) {
    tabController.addListener(() {
      if (tabController.index == 1 && !stateManager.canNavigateToSecondTab) {
        tabController.animateTo(0);
        return;
      }

      if (tabController.index != stateManager.currentIndex) {
        stateManager.currentIndex = tabController.index;
        onStateChanged();
      }
    });
  }

  static void goToNextTab({
    required TabController tabController,
    required RegistrationStateManager stateManager,
    required VoidCallback onStateChanged,
  }) {
    if (stateManager.currentIndex < tabController.length - 1) {
      stateManager.canNavigateToSecondTab = true;
      tabController.animateTo(stateManager.currentIndex + 1);
      onStateChanged();
    }
  }

  static void goToPreviousTab({
    required TabController tabController,
    required RegistrationStateManager stateManager,
  }) {
    if (stateManager.currentIndex > 0) {
      tabController.animateTo(stateManager.currentIndex - 1);
    }
  }
}