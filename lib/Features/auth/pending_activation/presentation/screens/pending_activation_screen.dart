// lib/Features/auth/pending_activation/presentation/screens/pending_activation_screen.dart
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
import '../../data/services/activation_timer_service.dart';

class PendingActivationScreen extends ConsumerStatefulWidget {
  const PendingActivationScreen({super.key});

  @override
  ConsumerState<PendingActivationScreen> createState() => _PendingActivationScreenState();
}

class _PendingActivationScreenState extends ConsumerState<PendingActivationScreen> {
  @override
  void initState() {
    super.initState();
    // استخدام addPostFrameCallback للتأكد من بناء الـ widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _checkInitialStatus();
      }
    });
  }
  
  Future<void> _checkInitialStatus() async {
    if (!mounted) return;
    
    try {
      final isActive = await ref.read(activationTimerProvider.notifier).checkActivationStatus();
      
      if (!mounted) return;
      
      if (isActive) {
        // استخدام Future.microtask لتجنب مشاكل السياق
        Future.microtask(() {
          if (mounted) {
            GlobalToast.showSuccess(
              context: context,
              message: 'تم تفعيل حسابك بنجاح! مرحباً بك في توصيل',
            );
            context.go(AppRoutes.home);
          }
        });
      }
    } catch (e) {
      print('خطأ في فحص الحالة الأولية: $e');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(activationTimerProvider);
    
    // الاستماع لتغيير حالة التفعيل
    ref.listen<ActivationTimerState>(
      activationTimerProvider,
      (previous, next) {
        if (!mounted) return;
        
        if (next.isActive && previous != null && !previous.isActive) {
          // استخدام Future.microtask لتجنب التحديث أثناء البناء
          Future.microtask(() {
            if (mounted) {
              GlobalToast.showSuccess(
                context: context,
                message: 'تم تفعيل حسابك بنجاح! مرحباً بك في توصيل',
              );
              context.go(AppRoutes.home);
            }
          });
        }
      },
    );
    
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildAnimation(),
                          const Gap(32),
                          _buildTitle(),
                          const Gap(16),
                          _buildDescription(),
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
                _buildActions(timerState.isExpired),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SvgPicture.asset(
          'assets/svg/Logo.svg',
          height: 40,
        ),
        IconButton(
          onPressed: _showLogoutDialog,
          icon: Icon(
            Icons.logout,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ],
    );
  }
  
  Widget _buildAnimation() {
    // في حالة عدم وجود ملف Lottie، استخدم CircularProgressIndicator
    return SizedBox(
      height: 200,
      width: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
            const Gap(16),
            Text(
              'جاري المعالجة...',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
      // إذا كان لديك ملف Lottie، استخدم هذا:
      // child: Lottie.asset(
      //   'assets/animations/waiting.json',
      //   repeat: true,
      // ),
    );
  }
  
  Widget _buildTitle() {
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
  
  Widget _buildDescription() {
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
  
  Widget _buildActions(bool isExpired) {
    if (isExpired) {
      return Column(
        children: [
          FillButton(
            label: 'تواصل مع الدعم',
            onPressed: _contactSupport,
            icon: const Icon(Icons.support_agent, color: Colors.white),
          ),
          const Gap(12),
          OutlinedCustomButton(
            label: 'تسجيل الخروج',
            onPressed: _performLogout,
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
          onPressed: _performLogout,
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
  
  void _contactSupport() {
    if (!mounted) return;
    
    GlobalToast.show(
      context: context,
      message: 'سيتم التواصل معك قريباً',
    );
  }
  
  void _showLogoutDialog() {
    if (!mounted) return;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _performLogout();
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
  
  Future<void> _performLogout() async {
    if (!mounted) return;
    
    try {
      await SharedPreferencesHelper.removeUser();
      await ActivationTimerService.clearRegistrationTime();
      
      if (!mounted) return;
      
      // استخدام Future.microtask لتجنب مشاكل السياق
      Future.microtask(() {
        if (mounted) {
          context.go(AppRoutes.login);
        }
      });
    } catch (e) {
      print('خطأ في تسجيل الخروج: $e');
    }
  }
}