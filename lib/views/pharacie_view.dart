import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:getxapp/controllers/cabinet_controller.dart';
import 'package:getxapp/controllers/pharmacie_controller.dart';
import 'package:latlong2/latlong.dart';

class PharmacyView extends GetView<PharmacyController> {
  const PharmacyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: isMobile
          ? AppBar(
              title: const Text(
                "Pharmacies",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              //backgroundColor: const Color(0xFF47C3A4),
              backgroundColor: Colors.blue,
              centerTitle: true,
            )
          : null,
      drawer: isMobile
          ? Drawer(
              child: ListView(
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.local_hospital,
                              size: 40, color: Colors.blue),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Pharmacies ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.medical_services),
                    title: const Text("doctors"),
                    onTap: () => Get.toNamed('/docteur'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.local_hospital),
                    title: const Text("cabinets"),
                    onTap: () => Get.toNamed('/cabinet'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text("Home"),
                    onTap: () => Get.toNamed('/home'),
                  ),
                ],
              ),
            )
          : null,
      body: Column(
        children: [
          if (!isMobile) const CustomNavbar(),
          SizedBox(
            height: 40,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: isMobile
                  ? Obx(() {
                      final showMap = controller.showMap.value;
                      return Column(
                        children: [
                          // Filters
                          SizedBox(
                            height: 40,
                            child: Row(
                              children: [
                                Flexible(
                                  child: SizedBox(
                                    width: isMobile
                                        ? MediaQuery.of(context).size.width *
                                            0.45
                                        : null,
                                    child: DropdownButtonFormField<String>(
                                      value: controller.selectedWillaya.value,
                                      items: controller.willayaDropdownItems,
                                      onChanged: controller.onWillayaChanged,
                                      isExpanded: true,
                                      decoration: inputDecoration('Willaya'),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Flexible(
                                  child: SizedBox(
                                    width: isMobile
                                        ? MediaQuery.of(context).size.width *
                                            0.45
                                        : null,
                                    child: DropdownButtonFormField<String>(
                                      value: controller.selectedMoughataa.value,
                                      items: controller.moughataaDropdownItems,
                                      onChanged: controller.onMoughataaChanged,
                                      decoration: inputDecoration('Moughataa'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Toggle between List and Map
                          ElevatedButton(
                            onPressed: () =>
                                controller.showMap.value = !showMap,
                            child: Text(showMap
                                ? "Voir la liste des pharmacies"
                                : "Voir la carte"),
                          ),
                          const SizedBox(height: 16),
                          // List or Map
                          Expanded(
                            child: showMap
                                ? FlutterMap(
                                    options: MapOptions(
                                      center: LatLng(18.0735, -15.9582),
                                      zoom: 6,
                                    ),
                                    children: [
                                      TileLayer(
                                        urlTemplate:
                                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                        userAgentPackageName: 'com.example.app',
                                      ),
                                      MarkerLayer(
                                        markers: controller.filteredPharmacies
                                            .map((pharmacy) => Marker(
                                                  point: LatLng(
                                                      pharmacy.latitude,
                                                      pharmacy.longitude),
                                                  width: 30,
                                                  height: 30,
                                                  builder: (context) => Tooltip(
                                                    message: pharmacy.name,
                                                    child: const Icon(
                                                      Icons.local_pharmacy,
                                                      color: Color(0xFF47C3A4),
                                                      size: 30,
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: controller
                                              .getPaginatedPharmacies()
                                              .length,
                                          itemBuilder: (context, index) {
                                            final pharmacy = controller
                                                    .getPaginatedPharmacies()[
                                                index];
                                            return ListTile(
                                              title: Text(
                                                pharmacy.name,
                                                style: const TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 16,
                                                ),
                                              ),
                                              subtitle: Text(
                                                '${pharmacy.distance?.toStringAsFixed(2)} km\n${pharmacy.willaya} - ${pharmacy.moughataa}',
                                              ),
                                              trailing: const Icon(
                                                Icons.local_pharmacy,
                                                color: Color(0xFF47C3A4),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      // Pagination
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              icon:
                                                  const Icon(Icons.arrow_back),
                                              onPressed:
                                                  controller.currentPage.value >
                                                          0
                                                      ? controller.previousPage
                                                      : null,
                                            ),
                                            Obx(() => Text(
                                                  'Page ${controller.currentPage.value + 1}/${controller.totalPages.value}',
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                )),
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.arrow_forward),
                                              onPressed:
                                                  controller.currentPage.value <
                                                          controller.totalPages
                                                                  .value -
                                                              1
                                                      ? controller.nextPage
                                                      : null,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      );
                    })
                  : Row(
                      children: [
                        // Sidebar and Map
                        Expanded(
                          flex: 2,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Pharmacies les plus proches',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Expanded(
                                    child: Obx(() {
                                      final paginatedPharmacies =
                                          controller.getPaginatedPharmacies();
                                      return Column(
                                        children: [
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount:
                                                  paginatedPharmacies.length,
                                              itemBuilder: (context, index) {
                                                final pharmacy =
                                                    paginatedPharmacies[index];
                                                return ListTile(
                                                  title: Text(
                                                    pharmacy.name,
                                                    style: const TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    '${pharmacy.distance?.toStringAsFixed(2)} km\n${pharmacy.willaya} - ${pharmacy.moughataa}',
                                                  ),
                                                  trailing: const Icon(
                                                    Icons.local_pharmacy,
                                                    color: Color(0xFF47C3A4),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                      Icons.arrow_back),
                                                  onPressed: controller
                                                              .currentPage
                                                              .value >
                                                          0
                                                      ? controller.previousPage
                                                      : null,
                                                ),
                                                Obx(() => Text(
                                                      'Page ${controller.currentPage.value + 1}/${controller.totalPages.value}',
                                                      style: const TextStyle(
                                                          fontSize: 14),
                                                    )),
                                                IconButton(
                                                  icon: const Icon(
                                                      Icons.arrow_forward),
                                                  onPressed: controller
                                                              .currentPage
                                                              .value <
                                                          controller.totalPages
                                                                  .value -
                                                              1
                                                      ? controller.nextPage
                                                      : null,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Obx(() =>
                                        DropdownButtonFormField<String>(
                                          value:
                                              controller.selectedWillaya.value,
                                          items:
                                              controller.willayaDropdownItems,
                                          onChanged:
                                              controller.onWillayaChanged,
                                          decoration:
                                              inputDecoration('Willaya'),
                                        )),
                                  ),
                                  const SizedBox(width: 13),
                                  Expanded(
                                    child: Obx(
                                        () => DropdownButtonFormField<String>(
                                              value: controller
                                                  .selectedMoughataa.value,
                                              items: controller
                                                  .moughataaDropdownItems,
                                              onChanged:
                                                  controller.onMoughataaChanged,
                                              decoration:
                                                  inputDecoration('Moughataa'),
                                            )),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: Obx(() => FlutterMap(
                                      options: MapOptions(
                                        center: LatLng(18.0735, -15.9582),
                                        zoom: 6,
                                      ),
                                      children: [
                                        TileLayer(
                                          urlTemplate:
                                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                          userAgentPackageName:
                                              'com.example.app',
                                        ),
                                        MarkerLayer(
                                          markers: controller.filteredPharmacies
                                              .map((pharmacy) => Marker(
                                                    point: LatLng(
                                                        pharmacy.latitude,
                                                        pharmacy.longitude),
                                                    width: 30,
                                                    height: 30,
                                                    builder: (context) =>
                                                        Tooltip(
                                                      message: pharmacy.name,
                                                      child: const Icon(
                                                        Icons.local_pharmacy,
                                                        color:
                                                            Color(0xFF47C3A4),
                                                        size: 30,
                                                      ),
                                                    ),
                                                  ))
                                              .toList(),
                                        ),
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF47C3A4)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF47C3A4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF47C3A4), width: 2),
      ),
    );
  }
}

// class PharmacyView extends GetView<PharmacyController> {
//   const PharmacyView({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final isMobile = MediaQuery.of(context).size.width < 600;
//
//     return Scaffold(
//       appBar: isMobile
//           ? AppBar(
//               title: const Text("Pharmacies"),
//               backgroundColor: const Color(0xFF47C3A4),
//             )
//           : null,
//       drawer: isMobile
//           ? Drawer(
//               child: ListView(
//                 children: [
//                   const DrawerHeader(
//                     decoration: BoxDecoration(
//                       color: Color(0xFF47C3A4),
//                     ),
//                     child: Text(
//                       "Navigation",
//                       style: TextStyle(color: Colors.white, fontSize: 20),
//                     ),
//                   ),
//                   ListTile(
//                     title: const Text("Option 1"),
//                     onTap: () {
//                       // Navigate or perform an action
//                     },
//                   ),
//                   ListTile(
//                     title: const Text("Option 2"),
//                     onTap: () {
//                       // Navigate or perform an action
//                     },
//                   ),
//                 ],
//               ),
//             )
//           : null,
//       body: Column(
//         children: [
//           if (!isMobile) const CustomNavbar(),
//           SizedBox(
//             height: 40,
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: isMobile
//                   ? Obx(() {
//                       final showMap = controller.showMap.value;
//                       return Column(
//                         children: [
//                           // Filters
//                           SizedBox(
//                             height: 40,
//                             child: Row(
//                               children: [
//                                 Flexible(
//                                   child: SizedBox(
//                                     width: isMobile
//                                         ? MediaQuery.of(context).size.width *
//                                             0.45
//                                         : null,
//                                     child: DropdownButtonFormField<String>(
//                                       value: controller.selectedWillaya.value,
//                                       items: controller.willayaDropdownItems,
//                                       onChanged: controller.onWillayaChanged,
//                                       isExpanded: true,
//                                       decoration: inputDecoration('Willaya'),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 15),
//                                 Flexible(
//                                   child: SizedBox(
//                                     width: isMobile
//                                         ? MediaQuery.of(context).size.width *
//                                             0.45
//                                         : null,
//                                     child: DropdownButtonFormField<String>(
//                                       value: controller.selectedMoughataa.value,
//                                       items: controller.moughataaDropdownItems,
//                                       onChanged: controller.onMoughataaChanged,
//                                       decoration: inputDecoration('Moughataa'),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           // Toggle between List and Map
//                           ElevatedButton(
//                             onPressed: () =>
//                                 controller.showMap.value = !showMap,
//                             child: Text(showMap
//                                 ? "Voir la liste des pharmacies"
//                                 : "Voir la carte"),
//                           ),
//                           const SizedBox(height: 16),
//                           // List or Map
//                           Expanded(
//                             child: showMap
//                                 ? FlutterMap(
//                                     options: MapOptions(
//                                       center: LatLng(18.0735, -15.9582),
//                                       zoom: 6,
//                                     ),
//                                     children: [
//                                       TileLayer(
//                                         urlTemplate:
//                                             'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                                         userAgentPackageName: 'com.example.app',
//                                       ),
//                                       MarkerLayer(
//                                         markers: controller.filteredPharmacies
//                                             .map((pharmacy) => Marker(
//                                                   point: LatLng(
//                                                       pharmacy.latitude,
//                                                       pharmacy.longitude),
//                                                   width: 30,
//                                                   height: 30,
//                                                   builder: (context) => Tooltip(
//                                                     message: pharmacy.name,
//                                                     child: Icon(
//                                                       Icons.local_pharmacy,
//                                                       color:
//                                                           pharmacy.openTonight
//                                                               ? const Color(
//                                                                   0xFF47C3A4)
//                                                               : Colors.red,
//                                                       size: 30,
//                                                     ),
//                                                   ),
//                                                 ))
//                                             .toList(),
//                                       ),
//                                     ],
//                                   )
//                                 : Column(
//                                     children: [
//                                       Expanded(
//                                         child: ListView.builder(
//                                           itemCount: controller
//                                               .getPaginatedPharmacies()
//                                               .length,
//                                           itemBuilder: (context, index) {
//                                             final pharmacy = controller
//                                                     .getPaginatedPharmacies()[
//                                                 index];
//                                             return ListTile(
//                                               title: Text(
//                                                 pharmacy.name,
//                                                 style: const TextStyle(
//                                                   fontFamily: 'Roboto',
//                                                   fontSize: 16,
//                                                 ),
//                                               ),
//                                               subtitle: Text(
//                                                 '${pharmacy.distance?.toStringAsFixed(2)} km\n${pharmacy.willaya} - ${pharmacy.moughataa}',
//                                               ),
//                                               trailing: Icon(
//                                                 Icons.local_pharmacy,
//                                                 color: pharmacy.openTonight
//                                                     ? const Color(0xFF47C3A4)
//                                                     : Colors.red,
//                                               ),
//                                             );
//                                           },
//                                         ),
//                                       ),
//                                       // Pagination
//                                       Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 8.0),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             IconButton(
//                                               icon:
//                                                   const Icon(Icons.arrow_back),
//                                               onPressed:
//                                                   controller.currentPage.value >
//                                                           0
//                                                       ? controller.previousPage
//                                                       : null,
//                                             ),
//                                             Obx(() => Text(
//                                                   'Page ${controller.currentPage.value + 1}/${controller.totalPages.value}',
//                                                   style: const TextStyle(
//                                                       fontSize: 14),
//                                                 )),
//                                             IconButton(
//                                               icon: const Icon(
//                                                   Icons.arrow_forward),
//                                               onPressed:
//                                                   controller.currentPage.value <
//                                                           controller.totalPages
//                                                                   .value -
//                                                               1
//                                                       ? controller.nextPage
//                                                       : null,
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                           ),
//                         ],
//                       );
//                     })
//                   : Row(
//                       children: [
//                         // Sidebar and Map (as in the original layout)
//                         Expanded(
//                           flex: 2,
//                           child: Card(
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const Text(
//                                     'Pharmacies les plus proches',
//                                     style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 8),
//                                   Expanded(
//                                     child: Obx(() {
//                                       final paginatedPharmacies =
//                                           controller.getPaginatedPharmacies();
//                                       return Column(
//                                         children: [
//                                           Expanded(
//                                             child: ListView.builder(
//                                               itemCount:
//                                                   paginatedPharmacies.length,
//                                               itemBuilder: (context, index) {
//                                                 final pharmacy =
//                                                     paginatedPharmacies[index];
//                                                 return ListTile(
//                                                   title: Text(
//                                                     pharmacy.name,
//                                                     style: const TextStyle(
//                                                       fontFamily: 'Roboto',
//                                                       fontSize: 16,
//                                                     ),
//                                                   ),
//                                                   subtitle: Text(
//                                                     '${pharmacy.distance?.toStringAsFixed(2)} km\n${pharmacy.willaya} - ${pharmacy.moughataa}',
//                                                   ),
//                                                   trailing: Icon(
//                                                     Icons.local_pharmacy,
//                                                     color: pharmacy.openTonight
//                                                         ? const Color(
//                                                             0xFF47C3A4)
//                                                         : Colors.red,
//                                                   ),
//                                                 );
//                                               },
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding:
//                                                 const EdgeInsets.only(top: 8.0),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.center,
//                                               children: [
//                                                 IconButton(
//                                                   icon: const Icon(
//                                                       Icons.arrow_back),
//                                                   onPressed: controller
//                                                               .currentPage
//                                                               .value >
//                                                           0
//                                                       ? controller.previousPage
//                                                       : null,
//                                                 ),
//                                                 Obx(() => Text(
//                                                       'Page ${controller.currentPage.value + 1}/${controller.totalPages.value}',
//                                                       style: const TextStyle(
//                                                           fontSize: 14),
//                                                     )),
//                                                 IconButton(
//                                                   icon: const Icon(
//                                                       Icons.arrow_forward),
//                                                   onPressed: controller
//                                                               .currentPage
//                                                               .value <
//                                                           controller.totalPages
//                                                                   .value -
//                                                               1
//                                                       ? controller.nextPage
//                                                       : null,
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       );
//                                     }),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 5,
//                           child: Column(
//                             children: [
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: Obx(() =>
//                                         DropdownButtonFormField<String>(
//                                           value:
//                                               controller.selectedWillaya.value,
//                                           items:
//                                               controller.willayaDropdownItems,
//                                           onChanged:
//                                               controller.onWillayaChanged,
//                                           decoration:
//                                               inputDecoration('Willaya'),
//                                         )),
//                                   ),
//                                   const SizedBox(width: 13),
//                                   Expanded(
//                                     child: Obx(
//                                         () => DropdownButtonFormField<String>(
//                                               value: controller
//                                                   .selectedMoughataa.value,
//                                               items: controller
//                                                   .moughataaDropdownItems,
//                                               onChanged:
//                                                   controller.onMoughataaChanged,
//                                               decoration:
//                                                   inputDecoration('Moughataa'),
//                                             )),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 16),
//                               Expanded(
//                                 child: Obx(() => FlutterMap(
//                                       options: MapOptions(
//                                         center: LatLng(18.0735, -15.9582),
//                                         zoom: 6,
//                                       ),
//                                       children: [
//                                         TileLayer(
//                                           urlTemplate:
//                                               'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                                           userAgentPackageName:
//                                               'com.example.app',
//                                         ),
//                                         MarkerLayer(
//                                           markers: controller.filteredPharmacies
//                                               .map((pharmacy) => Marker(
//                                                     point: LatLng(
//                                                         pharmacy.latitude,
//                                                         pharmacy.longitude),
//                                                     width: 30,
//                                                     height: 30,
//                                                     builder: (context) =>
//                                                         Tooltip(
//                                                       message: pharmacy.name,
//                                                       child: Icon(
//                                                         Icons.local_pharmacy,
//                                                         color:
//                                                             pharmacy.openTonight
//                                                                 ? const Color(
//                                                                     0xFF47C3A4)
//                                                                 : Colors.red,
//                                                         size: 30,
//                                                       ),
//                                                     ),
//                                                   ))
//                                               .toList(),
//                                         ),
//                                       ],
//                                     )),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   InputDecoration inputDecoration(String label) {
//     return InputDecoration(
//       labelText: label,
//       contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: const BorderSide(color: Color(0xFF47C3A4)),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: const BorderSide(color: Color(0xFF47C3A4)),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: const BorderSide(color: Color(0xFF47C3A4), width: 2),
//       ),
//     );
//   }
// }
