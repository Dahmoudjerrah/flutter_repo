import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getxapp/bindings/location_binding.dart';
import 'package:getxapp/home.dart';
import 'package:getxapp/splishsecreen.dart';
import 'package:getxapp/views/cabinet_view.dart';

import 'package:getxapp/views/doctours_view.dart';
import 'package:getxapp/views/pharacie_view.dart';
import 'mobile_url_strategy.dart'
    if (dart.library.html) 'web_url_strategy.dart';

void main() {
  configureApp();
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
      initialRoute: '/splash',
      getPages: [
        // GetPage(name: '/', page: () => HomePage()),
        GetPage(name: '/pharmacie', page: () => const PharmacyView()),
        GetPage(name: '/cabinet', page: () => LocationView()),
        GetPage(name: '/docteur', page: () => DoctorListView()),
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/splash', page: () => SplashScreen()),
      ],
      initialBinding: LocationBinding(),
    );
  }
}
