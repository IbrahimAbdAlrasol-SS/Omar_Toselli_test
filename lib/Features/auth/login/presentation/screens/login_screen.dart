import 'package:Tosell/core/config/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Tosell/features/auth/login/data/provider/auth_provider.dart';
import '../controllers/focus_controller.dart';
import '../widgets/login_header.dart';
import '../widgets/login_form_sheet.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late FocusNode _phoneFocusNode;
  late FocusNode _passwordFocusNode;
  
  bool _isTextFieldFocused = false;
  bool _isPasswordVisible = false;
  late DraggableScrollableController _scrollableController;
  late FocusController _focusController;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _scrollableController = DraggableScrollableController();
    _focusController = FocusController(
      scrollableController: _scrollableController,
      onFocusChanged: (isFocused) {
        setState(() {
          _isTextFieldFocused = isFocused;
        });
      },
    );
    _phoneFocusNode = _focusController.phoneFocusNode;
    _passwordFocusNode = _focusController.passwordFocusNode;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _focusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(authNotifierProvider);

    return loginState.when(
      data: (_) => _buildUi(context, loginState),
      loading: () => _buildUi(context, loginState),
      error: (error, stackTrace) => Center(child: Text(error.toString())),
    );
  }

  Widget _buildUi(BuildContext context, AsyncValue<void> loginState) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Column(children: [const LoginHeader()]),
            LoginFormSheet(
              scrollableController: _scrollableController,
              formKey: _formKey,
              phoneController: _phoneController,
              passwordController: _passwordController,
              phoneFocusNode: _phoneFocusNode,
              passwordFocusNode: _passwordFocusNode,
              isTextFieldFocused: _isTextFieldFocused,
              isPasswordVisible: _isPasswordVisible,
              onPasswordVisibilityToggle: () => setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              }),
              loginState: loginState,
            ),
          ],
        ),
      ),
    );
  }
}
