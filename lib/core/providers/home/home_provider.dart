// lib/core/providers/home/home_provider.dart
import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:Tosell/core/Model/home/Home.dart';
import 'package:Tosell/core/Services/home/home_service.dart';

part 'home_provider.g.dart';

@riverpod
class HomeNotifier extends _$HomeNotifier {
  final HomeService _service = HomeService();

  Future<Home?> get() async {
    return (await _service.getInfo());
  }

  @override
  FutureOr<Home> build() async {
    try {
      return await get() ?? Home();
    } catch (e) {
      // في حالة حدوث خطأ، نعيد Home فارغ بدلاً من رمي الخطأ
      return Home();
    }
  }
}