import 'dart:convert';

class TokenDecoderService {
  // فك تشفير JWT Token للحصول على البيانات
  static Map<String, dynamic>? decodeToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        return null;
      }
      
      // فك تشفير الجزء الثاني (payload)
      final payload = parts[1];
      
      // إضافة padding إذا لزم الأمر
      final normalizedPayload = base64.normalize(payload);
      
      // فك التشفير
      final payloadString = utf8.decode(base64.decode(normalizedPayload));
      
      // تحويل إلى Map
      return json.decode(payloadString);
    } catch (e) {
      print('خطأ في فك تشفير التوكن: $e');
      return null;
    }
  }
  
  // التحقق من حالة التفعيل من التوكن
  static bool? getIsActiveFromToken(String? token) {
    if (token == null) return null;
    
    final decodedToken = decodeToken(token);
    if (decodedToken == null) return null;
    
    // التوكن يحتوي على IsActive
    final isActiveString = decodedToken['IsActive']?.toString().toLowerCase();
    return isActiveString == 'true';
  }
}
