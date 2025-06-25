import 'package:Tosell/core/Model/home/Home.dart';
import 'package:Tosell/core/Client/BaseClient.dart';
import 'package:Tosell/core/Client/APIendpoint.dart';

class HomeService {
  final BaseClient<Home> baseClient;

  HomeService()
      : baseClient = BaseClient<Home>(fromJson: (json) => Home.fromJson(json));

  Future<Home?> getInfo() async {
    try {
      // var result = await baseClient.get(endpoint: 'dashboard/mobile');
      var result = await baseClient.get_noResponse(
          endpoint: DashboardEndpoints.mobileMerchant);
      // if (result.singleData == null) return Home();
      return result;
    } catch (e) {
      // في حالة فشل جلب البيانات، نعيد Home فارغ بدلاً من رمي الخطأ
      return Home();
    }
  }
}
