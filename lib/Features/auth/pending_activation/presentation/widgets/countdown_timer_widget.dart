import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CountdownTimerWidget extends StatelessWidget {
  final Duration remainingTime;
  final bool isExpired;

  const CountdownTimerWidget({
    super.key,
    required this.remainingTime,
    required this.isExpired,
  });

  @override
  Widget build(BuildContext context) {
    if (isExpired) {
      return _buildExpiredView(context);
    }
    
    final hours = remainingTime.inHours;
    final minutes = remainingTime.inMinutes.remainder(60);
    final seconds = remainingTime.inSeconds.remainder(60);
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTimeBox(
              context,
              value: seconds.toString().padLeft(2, '0'),
              label: 'ثانية',
            ),
            const Gap(12),
            _buildSeparator(context),
            const Gap(12),
            _buildTimeBox(
              context,
              value: minutes.toString().padLeft(2, '0'),
              label: 'دقيقة',
            ),
            const Gap(12),
            _buildSeparator(context),
            const Gap(12),
            _buildTimeBox(
              context,
              value: hours.toString().padLeft(2, '0'),
              label: 'ساعة',
            ),
          ],
        ),
        const Gap(24),
        Text(
          'الوقت المتبقي لتفعيل حسابك',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }
  
  Widget _buildTimeBox(BuildContext context, {required String value, required String label}) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
        const Gap(8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }
  
  Widget _buildSeparator(BuildContext context) {
    return Text(
      ':',
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
  
  Widget _buildExpiredView(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.timer_off,
          size: 80,
          color: Theme.of(context).colorScheme.error,
        ),
        const Gap(16),
        Text(
          'انتهت مهلة التفعيل',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        const Gap(8),
        Text(
          'يرجى التواصل مع الدعم الفني',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}