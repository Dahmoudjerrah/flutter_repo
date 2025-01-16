import 'package:get/get.dart';
import 'package:getxapp/controllers/cabinet_controller.dart';

class LocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocationController>(() => LocationController());
  }
}
