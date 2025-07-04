class ActivationTimerState {
  final DateTime registrationTime;
  final Duration remainingTime;
  final bool isExpired;
  final bool isActive;

  const ActivationTimerState({
    required this.registrationTime,
    required this.remainingTime,
    required this.isExpired,
    required this.isActive,
  });

  factory ActivationTimerState.initial() {
    return ActivationTimerState(
      registrationTime: DateTime.now(),
      remainingTime: const Duration(hours: 24),
      isExpired: false,
      isActive: false,
    );
  }

  ActivationTimerState copyWith({
    DateTime? registrationTime,
    Duration? remainingTime,
    bool? isExpired,
    bool? isActive,
  }) {
    return ActivationTimerState(
      registrationTime: registrationTime ?? this.registrationTime,
      remainingTime: remainingTime ?? this.remainingTime,
      isExpired: isExpired ?? this.isExpired,
      isActive: isActive ?? this.isActive,
    );
  }
}