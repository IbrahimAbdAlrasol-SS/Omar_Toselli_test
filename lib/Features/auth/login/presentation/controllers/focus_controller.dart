import 'package:flutter/material.dart';
import '../constants/login_dimensions.dart';

class FocusController {
  final DraggableScrollableController _scrollableController;
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final Function(bool) _onFocusChanged;

  FocusController({
    required DraggableScrollableController scrollableController,
    required Function(bool) onFocusChanged,
  }) : _scrollableController = scrollableController,
       _onFocusChanged = onFocusChanged {
    initialize();
  }

  FocusNode get phoneFocusNode => _phoneFocusNode;
  FocusNode get passwordFocusNode => _passwordFocusNode;

  void initialize() {
    _phoneFocusNode.addListener(_handleFocusChange);
    _passwordFocusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    final isFocused = _phoneFocusNode.hasFocus || _passwordFocusNode.hasFocus;
    _onFocusChanged(isFocused);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollableController.isAttached) {
        _animateSheet(isFocused);
      }
    });
  }

  void _animateSheet(bool isFocused) {
    final targetSize = isFocused 
        ? LoginDimensions.focusedSheetSize 
        : LoginDimensions.unfocusedSheetSize;
    
    _scrollableController.animateTo(
      targetSize,
      duration: const Duration(milliseconds: LoginDimensions.animationDuration),
      curve: Curves.easeInOut,
    );
  }

  void dispose() {
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
  }
}