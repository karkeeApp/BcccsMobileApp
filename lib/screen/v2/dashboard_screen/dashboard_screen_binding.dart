/// Generated by Flutter GetX Starter on 2021-08-01 19:57
import 'package:get/get.dart';

import 'dashboard_screen_logic.dart';

class DashboardScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardScreenLogic>(
      () => DashboardScreenLogic(),
    );
  }
}