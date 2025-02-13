import 'package:get/get.dart';
import 'package:getxapp/controllers/cabinet_controller.dart';
import 'package:getxapp/controllers/pharmacie_controller.dart';

class LocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocationController>(() => LocationController());
    Get.lazyPut<PharmacyController>(() => PharmacyController());
  }
}
