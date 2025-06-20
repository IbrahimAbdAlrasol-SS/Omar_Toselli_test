import 'dart:convert';
import 'package:Tosell/core/Model/auth/PendingActivation.dart';
import 'package:Tosell/core/Client/BaseClient.dart';
import 'package:Tosell/core/Client/APIendpoint.dart';
import 'package:Tosell/core/helpers/SharedPreferencesHelper.dart';

class PendingActivationService {
  /// جلب حالة انتظار التفعيل من الخادم
  Future<Map<String, dynamic>> getPendingActivationStatus() async {
    try {
      final user = await SharedPreferencesHelper.getUser();
      if (user?.token == null) {
        return {'data': null, 'error': 'لم يتم العثور على رمز المصادقة'};
      }

      final client =
          BaseClient<PendingActivation>(fromJson: PendingActivation.fromJson);
      final response = await client.get(
        endpoint: AuthEndpoints.pendingActivationStatus,
      );

      if (response.errorType == null &&
          (response.data?.isNotEmpty == true || response.singleData != null)) {
        return {
          'data': response.singleData ??
              (response.data?.isNotEmpty == true ? response.data!.first : null),
          'error': null
        };
      } else {
        return {'data': null, 'error': response.message ?? 'حدث خطأ غير متوقع'};
      }
    } catch (e) {
      print('خطأ في getPendingActivationStatus: $e');
      return {'data': null, 'error': 'حدث خطأ في الشبكة'};
    }
  }

  /// التحقق من حالة التفعيل
  Future<Map<String, dynamic>> checkActivationStatus() async {
    try {
      final user = await SharedPreferencesHelper.getUser();
      if (user?.token == null) {
        return {
          'isActivated': false,
          'error': 'لم يتم العثور على رمز المصادقة'
        };
      }

      final client = BaseClient<Map<String, dynamic>>();
      final response = await client.get(
        endpoint: AuthEndpoints.checkActivation,
      );

      if (response.errorType == null &&
          (response.data?.isNotEmpty == true || response.singleData != null)) {
        final data = response.singleData ?? response.data!.first;
        return {'isActivated': data['isActivated'] ?? false, 'error': null};
      } else {
        return {
          'isActivated': false,
          'error': response.message ?? 'حدث خطأ غير متوقع'
        };
      }
    } catch (e) {
      print('خطأ في checkActivationStatus: $e');
      return {'isActivated': false, 'error': 'حدث خطأ في الشبكة'};
    }
  }

  /// تسجيل الخروج
  Future<Map<String, dynamic>> logout() async {
    try {
      final user = await SharedPreferencesHelper.getUser();

      // محاولة إرسال طلب تسجيل الخروج للخادم
      try {
        final client = BaseClient<Map<String, dynamic>>();
        await client.create(
          endpoint: AuthEndpoints.logout,
          data: {},
        );
      } catch (e) {
        // في حالة فشل الطلب، سنستمر في تسجيل الخروج محلياً
        print('فشل في إرسال طلب تسجيل الخروج للخادم: $e');
      }

      // مسح البيانات المحلية
      await SharedPreferencesHelper.removeUser();

      return {'success': true, 'error': null};
    } catch (e) {
      print('خطأ في logout: $e');
      return {'success': false, 'error': 'حدث خطأ أثناء تسجيل الخروج'};
    }
  }

  /// إرسال طلب للدعم الفني
  Future<Map<String, dynamic>> contactSupport({
    required String message,
    required String contactMethod,
  }) async {
    try {
      final user = await SharedPreferencesHelper.getUser();
      if (user?.token == null) {
        return {'success': false, 'error': 'لم يتم العثور على رمز المصادقة'};
      }

      final client = BaseClient<Map<String, dynamic>>();
      final response = await client.create(
        endpoint: AuthEndpoints.contactSupport,
        data: {
          'message': message,
          'contactMethod': contactMethod,
          'type': 'pending_activation_inquiry',
        },
      );

      if (response.errorType == null) {
        return {'success': true, 'error': null};
      } else {
        return {
          'success': false,
          'error': response.message ?? 'فشل في إرسال الرسالة'
        };
      }
    } catch (e) {
      print('خطأ في contactSupport: $e');
      return {'success': false, 'error': 'حدث خطأ في الشبكة'};
    }
  }

  /// إنشاء بيانات وهمية للاختبار (مؤقت)
  PendingActivation createMockData({
    String? fullName,
    String? brandName,
    String? phoneNumber,
  }) {
    final now = DateTime.now();
    final activationDeadline = now.add(const Duration(hours: 24));

    return PendingActivation(
      userId: 'mock_user_id',
      fullName: fullName ?? 'متجر توصيل',
      brandName: brandName ?? 'متجر توصيل',
      phoneNumber: phoneNumber ?? '0771 333 4945',
      registrationTime: now,
      activationDeadline: activationDeadline,
      remainingTime: activationDeadline.difference(now),
      isExpired: false,
      token: 'mock_token',
    );
  }
}
