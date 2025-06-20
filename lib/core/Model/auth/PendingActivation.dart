class PendingActivation {
  final String? userId;
  final String? fullName;
  final String? brandName;
  final String? phoneNumber;
  final String? profileImage;
  final DateTime? registrationTime;
  final DateTime? activationDeadline;
  final Duration? remainingTime;
  final bool isExpired;
  final String? token;

  PendingActivation({
    this.userId,
    this.fullName,
    this.brandName,
    this.phoneNumber,
    this.profileImage,
    this.registrationTime,
    this.activationDeadline,
    this.remainingTime,
    this.isExpired = false,
    this.token,
  });

  factory PendingActivation.fromJson(Map<String, dynamic> json) {
    final registrationTime = json['registrationTime'] != null
        ? DateTime.parse(json['registrationTime'])
        : null;
    final activationDeadline = json['activationDeadline'] != null
        ? DateTime.parse(json['activationDeadline'])
        : null;

    return PendingActivation(
      userId: json['userId'],
      fullName: json['fullName'],
      brandName: json['brandName'],
      phoneNumber: json['phoneNumber'],
      profileImage: json['profileImage'],
      registrationTime: registrationTime,
      activationDeadline: activationDeadline,
      remainingTime: activationDeadline != null
          ? activationDeadline.difference(DateTime.now())
          : null,
      isExpired: activationDeadline != null
          ? DateTime.now().isAfter(activationDeadline)
          : false,
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'brandName': brandName,
      'phoneNumber': phoneNumber,
      'profileImage': profileImage,
      'registrationTime': registrationTime?.toIso8601String(),
      'activationDeadline': activationDeadline?.toIso8601String(),
      'isExpired': isExpired,
      'token': token,
    };
  }

  PendingActivation copyWith({
    String? userId,
    String? fullName,
    String? brandName,
    String? phoneNumber,
    String? profileImage,
    DateTime? registrationTime,
    DateTime? activationDeadline,
    Duration? remainingTime,
    bool? isExpired,
    String? token,
  }) {
    return PendingActivation(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      brandName: brandName ?? this.brandName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImage: profileImage ?? this.profileImage,
      registrationTime: registrationTime ?? this.registrationTime,
      activationDeadline: activationDeadline ?? this.activationDeadline,
      remainingTime: remainingTime ?? this.remainingTime,
      isExpired: isExpired ?? this.isExpired,
      token: token ?? this.token,
    );
  }

  // دالة لحساب الوقت المتبقي
  Duration? calculateRemainingTime() {
    if (activationDeadline == null) return null;
    final now = DateTime.now();
    if (now.isAfter(activationDeadline!)) return Duration.zero;
    return activationDeadline!.difference(now);
  }

  // دالة للتحقق من انتهاء المدة
  bool get isActivationExpired {
    if (activationDeadline == null) return false;
    return DateTime.now().isAfter(activationDeadline!);
  }

  // دالة لتنسيق الوقت المتبقي
  String get formattedRemainingTime {
    final remaining = calculateRemainingTime();
    if (remaining == null || remaining.isNegative) return "00:00:00";
    
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes % 60;
    final seconds = remaining.inSeconds % 60;
    
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }
}