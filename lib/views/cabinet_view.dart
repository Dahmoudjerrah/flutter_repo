import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:getxapp/controllers/cabinet_controller.dart';
import 'package:latlong2/latlong.dart';

class LocationView extends GetView<LocationController> {
  const LocationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomNavbar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Sidebar with nearest cabinets
                  Expanded(
                    flex: 2,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Cabinets les plus proches',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: Obx(() {
                                final paginatedCabinets =
                                    controller.getPaginatedCabinets();
                                return Column(
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: paginatedCabinets.length,
                                        itemBuilder: (context, index) {
                                          final cabinet =
                                              paginatedCabinets[index];
                                          return ListTile(
                                            title: Text(
                                              cabinet.nom,
                                              style: const TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 16,
                                              ),
                                            ),
                                            subtitle: Text(
                                              '${cabinet.distance?.toStringAsFixed(2)} km\n${cabinet.willaya} - ${cabinet.moughataa}',
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    // Pagination controls
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.arrow_back),
                                            onPressed:
                                                controller.currentPage.value > 0
                                                    ? controller.previousPage
                                                    : null,
                                          ),
                                          Obx(() => Text(
                                                'Page ${controller.currentPage.value + 1}/${controller.totalPages.value}',
                                                style: const TextStyle(
                                                    fontSize: 14),
                                              )),
                                          IconButton(
                                            icon:
                                                const Icon(Icons.arrow_forward),
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
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Map and filters
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        // Filters
                        Row(
                          children: [
                            Expanded(
                              child: Obx(() => DropdownButtonFormField<String>(
                                    value: controller.selectedWillaya.value,
                                    items: controller.willayaDropdownItems,
                                    onChanged: controller.onWillayaChanged,
                                    decoration: inputDecoration(
                                        'Sélectionner une Willaya'),
                                  )),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Obx(() => DropdownButtonFormField<String>(
                                    value: controller.selectedMoughataa.value,
                                    items: controller.moughataaDropdownItems,
                                    onChanged: controller.onMoughataaChanged,
                                    decoration: inputDecoration(
                                        'Sélectionner une Moughataa'),
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Map
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
                                    userAgentPackageName: 'com.example.app',
                                  ),
                                  MarkerLayer(
                                    markers: controller.filteredCabinets
                                        .map((cabinet) => Marker(
                                              point: LatLng(cabinet.latitude,
                                                  cabinet.longitude),
                                              width: 30,
                                              height: 30,
                                              builder: (context) => Tooltip(
                                                message: cabinet.nom,
                                                child: const Icon(
                                                  Icons.location_pin,
                                                  color: Color(0xFF47C3A4),
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
