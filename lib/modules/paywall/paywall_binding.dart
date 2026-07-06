import 'package:get/get.dart';

import 'paywall_controller.dart';

class PaywallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaywallController>(() => PaywallController());
  }
}
