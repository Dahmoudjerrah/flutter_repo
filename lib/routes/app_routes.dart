import 'package:getxapp/views/cabinet_view.dart';
import 'package:get/get.dart';

class AppRoutes {
  static final routes = [
    // GetPage(
    //   name: '/pharmacie',
    //   page: () => const PharmacieView(),
    // ),
    GetPage(
      name: '/cabinet',
      page: () => const LocationView(),
    ),
    // GetPage(
    //   name: '/docteur',
    //   page: () => const DocteurView(),
    // ),
  ];
}
