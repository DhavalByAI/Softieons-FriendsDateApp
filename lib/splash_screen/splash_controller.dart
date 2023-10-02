import 'package:get/get.dart';
import 'package:new_friends_date_app/utils/fatch_api.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    fetchApi(
      url: 'get_walkthrough',
      get: true,
      onSucess: (val) {
        SplashBanner = val['data'] as List;
        update();
      },
    ).then((val) async {});
    super.onInit();
  }

  List SplashBanner = [];

  Rx<int> currPage = 0.obs;
}
