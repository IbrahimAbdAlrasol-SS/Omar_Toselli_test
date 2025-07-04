// lib/core/utils/helpers/SharedPreferencesHelper.dart
import 'dart:convert';
import 'package:Tosell/core/model_core/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _tokenKey = 'token';
  static const String _userKey = 'user';

  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString(_userKey, userJson);
  }

  static Future<void> updateUser(User newUser) async {
    final prefs = await SharedPreferences.getInstance();

    // Load existing user if any
    final existingUserJson = prefs.getString(_userKey);
    User? existingUser;
    
    if (existingUserJson != null) {
      try {
        existingUser = User.fromJson(jsonDecode(existingUserJson));
      } catch (e) {
        print('Error parsing existing user: $e');
      }
    }

    final updatedUser = User(
      id: newUser.id ?? existingUser?.id,
      fullName: newUser.fullName ?? existingUser?.fullName,
      phoneNumber: newUser.phoneNumber ?? existingUser?.phoneNumber,
      img: newUser.img ?? existingUser?.img,
      userName: newUser.userName ?? existingUser?.userName,
      token: newUser.token ?? existingUser?.token,
      role: newUser.role ?? existingUser?.role,
      zone: newUser.zone ?? existingUser?.zone,
      branch: newUser.branch ?? existingUser?.branch,
      type: newUser.type ?? existingUser?.type,
      deleted: newUser.deleted ?? existingUser?.deleted,
      creationDate: newUser.creationDate ?? existingUser?.creationDate,
      isActive: newUser.isActive ?? existingUser?.isActive, // ✅ إضافة isActive
    );

    final updatedJson = jsonEncode(updatedUser.toJson());
    await prefs.setString(_userKey, updatedJson);
  }

  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson == null) return null;
    
    try {
      return User.fromJson(jsonDecode(userJson));
    } catch (e) {
      print('Error parsing user from SharedPreferences: $e');
      return null;
    }
  }

  static Future<void> removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}