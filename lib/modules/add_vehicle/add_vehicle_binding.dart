import 'package:get/get.dart';

import 'add_vehicle_controller.dart';

class AddVehicleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddVehicleController>(() => AddVehicleController());
  }
}
