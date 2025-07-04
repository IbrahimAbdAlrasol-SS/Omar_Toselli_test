import 'package:Tosell/Features/auth/pending_activation/domain/entities/activation_timer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:Tosell/core/config/routes/app_router.dart';
import 'package:Tosell/core/widgets/buttons/FillButton.dart';
import 'package:Tosell/core/widgets/buttons/OutlineButton.dart';
import 'package:Tosell/core/utils/extensions/GlobalToast.dart';
import 'package:Tosell/core/utils/helpers/SharedPreferencesHelper.dart';
import '../providers/activation_timer_provider.dart';
import '../widgets/countdown_timer_widget.dart';

class PendingActivationScreen extends ConsumerStatefulWidget {
  const PendingActivationScreen({super.key});

  @override
  ConsumerState<PendingActivationScreen> createState() => _PendingActivationScreenState();
}

class _PendingActivationScreenState extends ConsumerState<PendingActivationScreen> {
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _checkInitialStatus();
  }
  
  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
  
  Future<void> _checkInitialStatus() async {
    // تأخير صغير للتأكد من بناء الـ widget
    await Future.delayed(const Duration(milliseconds: 100));
    
    if (_isDisposed || !mounted) return;
    
    // فحص فوري عند فتح الشاشة
    final isActive = await ref.read(activationTimerProvider.notifier).checkActivationStatus();
    
    if (_isDisposed || !mounted) return;
    
    if (isActive) {
      _navigateToHome();
    }
  }
  
  void _navigateToHome() {
    if (_isDisposed || !mounted) return;
    
    GlobalToast.showSuccess(
      context: context,
      message: 'تم تفعيل حسابك بنجاح! مرحباً بك في توصيل',
    );
    
    if (_isDisposed || !mounted) return;
    
    context.go(AppRoutes.home);
  }
  
  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(activationTimerProvider);
    
    // الاستماع لتغيير حالة التفعيل
    ref.listen<ActivationTimerState>(activationTimerProvider, (previous, next) {
      if (_isDisposed || !mounted) return;
      
      if (next.isActive && previous != null && !previous.isActive) {
        _navigateToHome();
      }
    });
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildAnimation(),
                        const Gap(32),
                        _buildTitle(context),
                        const Gap(16),
                        _buildDescription(context),
                        const Gap(48),
                        CountdownTimerWidget(
                          remainingTime: timerState.remainingTime,
                          isExpired: timerState.isExpired,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _buildActions(context, timerState.isExpired),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SvgPicture.asset(
          'assets/svg/Logo.svg',
          height: 40,
        ),
        IconButton(
          onPressed: () => _showLogoutDialog(context),
          icon: Icon(
            Icons.logout,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ],
    );
  }
  
  Widget _buildAnimation() {
    return SizedBox(
      height: 200,
      width: 200,
      child: Lottie.asset(
        'assets/animations/waiting.json',
        repeat: true,
      ),
    );
  }
  
  Widget _buildTitle(BuildContext context) {
    return Text(
      'حسابك قيد المراجعة',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      textAlign: TextAlign.center,
    );
  }
  
  Widget _buildDescription(BuildContext context) {
    return Text(
      'شكراً لتسجيلك في منصة توصيل! حسابك حالياً قيد المراجعة من قبل فريقنا.\nسيتم تفعيل حسابك خلال 24 ساعة كحد أقصى.',
      style: TextStyle(
        fontSize: 16,
        color: Theme.of(context).colorScheme.secondary,
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }
  
  Widget _buildActions(BuildContext context, bool isExpired) {
    if (isExpired) {
      return Column(
        children: [
          FillButton(
            label: 'تواصل مع الدعم',
            onPressed: () => _contactSupport(context),
            icon: const Icon(Icons.support_agent, color: Colors.white),
          ),
          const Gap(12),
          OutlinedCustomButton(
            label: 'تسجيل الخروج',
            onPressed: () => _logout(context),
          ),
        ],
      );
    }
    
    return Column(
      children: [
        Text(
          'ملاحظة: سيتم تحديث حالة حسابك تلقائياً',
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const Gap(16),
        TextButton(
          onPressed: () => _logout(context),
          child: Text(
            'تسجيل الخروج',
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
      ],
    );
  }
  
  void _contactSupport(BuildContext context) {
    if (_isDisposed || !mounted) return;
    
    GlobalToast.show(
      context: context,
      message: 'سيتم التواصل معك قريباً',
    );
  }
  
  void _showLogoutDialog(BuildContext context) {
    if (_isDisposed || !mounted) return;
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _logout(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }
  
  Future<void> _logout(BuildContext context) async {
    if (_isDisposed || !mounted) return;
    
    await SharedPreferencesHelper.removeUser();
    
    if (_isDisposed || !mounted) return;
    
    context.go(AppRoutes.login);
  }
}