import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getxapp/bindings/location_binding.dart';
import 'package:getxapp/routes/app_routes.dart';
import 'package:getxapp/views/cabinet_view.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() {
  setUrlStrategy(PathUrlStrategy());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Cabinet Locator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: const LocationView(),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const LocationView()),
        //GetPage(name: '/pharmacie', page: () => const PharmacieView()),
        GetPage(name: '/cabinet', page: () => const LocationView()),
        // GetPage(name: '/docteur', page: () => const DocteurView()),
      ],
      initialBinding: LocationBinding(),
    );
  }
}
