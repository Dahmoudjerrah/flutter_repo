import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getxapp/models/cabinet_model.dart';
import 'package:getxapp/models/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:geolocator/geolocator.dart';

class LocationController extends GetxController {
  RxBool showCabinetList = true.obs;
  final showMap = false.obs;
  final RxString selectedWillaya = ''.obs;
  final RxString selectedMoughataa = ''.obs;
  final RxList<Cabinet> allCabinets = <Cabinet>[].obs;
  final RxList<Cabinet> filteredCabinets = <Cabinet>[].obs;
  final RxList<Cabinet> nearestCabinets = <Cabinet>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<double?> userLat = Rx<double?>(null);
  final Rx<double?> userLng = Rx<double?>(null);

  final RxInt currentPage = 0.obs;
  final int cabinetsPerPage = 5;
  final RxInt totalPages = 0.obs;

  final List<Location> willayas = [
    Location(name: "Hodh Chargui", value: "HODH_CHARGUI"),
    Location(name: "Hodh El Gharbi", value: "HODH_EL_GHARBI"),
    Location(name: "Assaba", value: "ASSABA"),
    Location(name: "Gorgol", value: "GORGOL"),
    Location(name: "Brakna", value: "BRAKNA"),
    Location(name: "Trarza", value: "TRARZA"),
    Location(name: "Adrar", value: "ADRAR"),
    Location(name: "Dakhlet Nouadhibou", value: "DAKHLET_NOUADHIBOU"),
    Location(name: "Tagant", value: "TAGANT"),
    Location(name: "Guidimagha", value: "GUIDIMAGHA"),
    Location(name: "Tiris Zemmour", value: "TIRIS_ZEMMOUR"),
    Location(name: "Inchiri", value: "INCHIRI"),
    Location(name: "Nouakchott Ouest", value: "NOUAKCHOTT_OUEST"),
    Location(name: "Nouakchott Nord", value: "NOUAKCHOTT_NORD"),
    Location(name: "Nouakchott Sud", value: "NOUAKCHOTT_SUD"),
  ];

  final Map<String, List<Location>> moughataasByWillaya = {
    "HODH_CHARGUI": [
      Location(name: "Nema", value: "NEMA"),
      Location(name: "Amourj", value: "AMOURJ"),
      Location(name: "Bassiknou", value: "BASSIKNOU"),
      Location(name: "Djiguenni", value: "DJIGUENNI"),
      Location(name: "Timbedra", value: "TIMBEDRA"),
      Location(name: "Oualata", value: "OUALATA"),
    ],
    "HODH_EL_GHARBI": [
      Location(name: "Aioun", value: "AIOUN"),
      Location(name: "Tamcheket", value: "TAMCHEKET"),
      Location(name: "Koubenni", value: "KOUBENNI"),
      Location(name: "Tintane", value: "TINTANE"),
    ],
    "ASSABA": [
      Location(name: "Kiffa", value: "KIFFA"),
      Location(name: "Guerou", value: "GUEROU"),
      Location(name: "Kankossa", value: "KANKOSSA"),
      Location(name: "Boumdeid", value: "BOUMDEID"),
    ],
    "GORGOL": [
      Location(name: "Kaédi", value: "KAEDI"),
      Location(name: "M'Bout", value: "MBOUT"),
      Location(name: "Maghama", value: "MAGHAMA"),
      Location(name: "Monguel", value: "MONGUEL"),
    ],
    "BRAKNA": [
      Location(name: "Aleg", value: "ALEG"),
      Location(name: "Magta Lahjar", value: "MAGTA_LAHJAR"),
      Location(name: "Boghe", value: "BOGHE"),
      Location(name: "M'Bagne", value: "MBAGNE"),
      Location(name: "Bababe", value: "BABABE"),
    ],
    "TRARZA": [
      Location(name: "Rosso", value: "ROSSO"),
      Location(name: "R'Kiz", value: "RKIZ"),
      Location(name: "Boutilimit", value: "BOUTILIMIT"),
      Location(name: "Mederdra", value: "MEDERDRA"),
      Location(name: "Ouad Naga", value: "OUAD_NAGA"),
    ],
    "ADRAR": [
      Location(name: "Atar", value: "ATAR"),
      Location(name: "Chinguetti", value: "CHINGUITTI"),
      Location(name: "Ouadane", value: "OUADANE"),
      Location(name: "Aoujeft", value: "AOUJEFT"),
    ],
    "DAKHLET_NOUADHIBOU": [
      Location(name: "Nouadhibou", value: "NOUADHIBOU"),
    ],
    "TAGANT": [
      Location(name: "Tidjikja", value: "TIDJIKJA"),
      Location(name: "Moudjeria", value: "MOUDJERIA"),
    ],
    "GUIDIMAGHA": [
      Location(name: "Sélibaby", value: "SELIBABY"),
      Location(name: "Ould Yengé", value: "OULD_YENGE"),
    ],
    "TIRIS_ZEMMOUR": [
      Location(name: "Zouérate", value: "ZOUERATE"),
      Location(name: "F'Dérik", value: "FDERIK"),
      Location(name: "Bir Moghrein", value: "BIR_MOGHREIN"),
    ],
    "INCHIRI": [
      Location(name: "Akjoujt", value: "AKJOUJT"),
    ],
    "NOUAKCHOTT_OUEST": [
      Location(name: "Tevragh-Zeina", value: "TEVRAGH_ZEINA"),
      Location(name: "Ksar", value: "KSAR"),
      Location(name: "Sebkha", value: "SEBKHA"),
    ],
    "NOUAKCHOTT_NORD": [
      Location(name: "Dar Naim", value: "DAR_NAIM"),
      Location(name: "Toujounine", value: "TOUJOUNINE"),
      Location(name: "Teyarett", value: "TEYARETT"),
    ],
    "NOUAKCHOTT_SUD": [
      Location(name: "Arafat", value: "ARAFAT"),
      Location(name: "El Mina", value: "EL_MINA"),
      Location(name: "Riyad", value: "RIYAD"),
    ],
  };

  @override
  void onInit() {
    super.onInit();
    fetchCabinets();
    getUserLocation();
  }

  List<Cabinet> getPaginatedCabinets() {
    final startIndex = currentPage.value * cabinetsPerPage;
    final endIndex = startIndex + cabinetsPerPage;
    if (nearestCabinets.isEmpty) return [];
    return nearestCabinets.sublist(
      startIndex,
      endIndex > nearestCabinets.length ? nearestCabinets.length : endIndex,
    );
  }

  void nextPage() {
    if (currentPage.value < totalPages.value - 1) {
      currentPage.value++;
    }
  }

  void toggleMapView() {
    showMap.value = !showMap.value;
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
    }
  }

  void updateTotalPages() {
    totalPages.value = (nearestCabinets.length / cabinetsPerPage).ceil();
  }

  Future<void> fetchCabinets() async {
    try {
      isLoading(true);
      final response = await http
          .get(Uri.parse('http://127.0.0.1:8947/api/cabinets'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        allCabinets.value =
            jsonData.map((data) => Cabinet.fromJson(data)).toList();
        updateFilteredCabinets();
        updateNearestCabinets();
      }
    } catch (e) {
      print('Erreur lors de la récupération des cabinets: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> getUserLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      userLat.value = position.latitude;
      userLng.value = position.longitude;
      updateNearestCabinets();
    } catch (e) {
      print('Erreur lors de la récupération de la position: $e');
    }
  }

  // Calcul de distance
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0; // Rayon de la Terre en kilomètres
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }

  // Mise à jour des cabinets les plus proches
  void updateNearestCabinets() {
    if (userLat.value != null && userLng.value != null) {
      final cabinetsWithDistance = allCabinets.map((cabinet) {
        cabinet.distance = calculateDistance(
          userLat.value!,
          userLng.value!,
          cabinet.latitude,
          cabinet.longitude,
        );
        return cabinet;
      }).toList();

      cabinetsWithDistance
          .sort((a, b) => (a.distance ?? 0).compareTo(b.distance ?? 0));
      nearestCabinets.value = cabinetsWithDistance;
      updateTotalPages();
      currentPage.value = 0; // Réinitialiser à la première page
    }
  }

  // Mise à jour des cabinets filtrés
  void updateFilteredCabinets() {
    filteredCabinets.value = allCabinets.where((cabinet) {
      final willayaMatch =
          selectedWillaya.isEmpty || cabinet.willaya == selectedWillaya.value;
      final moughataaMatch = selectedMoughataa.isEmpty ||
          cabinet.moughataa == selectedMoughataa.value;
      return willayaMatch && moughataaMatch;
    }).toList();
  }

  // Obtention des éléments du dropdown pour les willayas
  List<DropdownMenuItem<String>> get willayaDropdownItems {
    return <DropdownMenuItem<String>>[
      const DropdownMenuItem<String>(
        value: "",
        child: Text(" Willaya"),
      ),
      ...willayas.map((Location location) {
        return DropdownMenuItem<String>(
          value: location.value,
          child: Text(location.name),
        );
      }).toList(),
    ];
  }

  // Obtention des éléments du dropdown pour les moughataas
  List<DropdownMenuItem<String>> get moughataaDropdownItems {
    if (selectedWillaya.isEmpty) {
      return <DropdownMenuItem<String>>[
        const DropdownMenuItem<String>(
          value: "",
          child: Text(" Moughataa"),
        ),
      ];
    }

    final moughataaList = moughataasByWillaya[selectedWillaya.value] ?? [];
    return <DropdownMenuItem<String>>[
      const DropdownMenuItem<String>(
        value: "",
        child: Text(" Moughataa"),
      ),
      ...moughataaList.map((Location location) {
        return DropdownMenuItem<String>(
          value: location.value,
          child: Text(location.name),
        );
      }).toList(),
    ];
  }

  // Gestionnaires d'événements pour les changements de sélection
  void onWillayaChanged(String? value) {
    if (value != null) {
      selectedWillaya.value = value;
      selectedMoughataa.value = ''; // Réinitialiser la moughataa sélectionnée
      updateFilteredCabinets();
    }
  }

  void onMoughataaChanged(String? value) {
    if (value != null) {
      selectedMoughataa.value = value;
      updateFilteredCabinets();
    }
  }
}

class NavbarLink extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const NavbarLink({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentRoute = Get.currentRoute;
    final isActive = currentRoute == '/${title.toLowerCase()}';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            title,
            style: TextStyle(
              color: isActive ? const Color(0xFF47C3A4) : Colors.grey[700],
              fontSize: 14,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomNavbar extends StatelessWidget {
  const CustomNavbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 768;
    final currentRoute = Get.currentRoute;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
      ),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          constraints: const BoxConstraints(maxWidth: 1280),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo cliquable pour retourner à l'accueil
              InkWell(
                onTap: () => Get.toNamed('/'),
                child: Image.asset(
                  'assets/images/loc.png',
                  width: 50,
                  height: 50,
                ),
              ),

              // Navigation links
              if (!isMobile)
                Row(
                  children: [
                    NavbarLink(
                      title: 'Pharmacies',
                      onTap: () => Get.toNamed('/pharmacie'),
                    ),
                    const SizedBox(width: 24),
                    NavbarLink(
                      title: 'Cabinet',
                      onTap: () => Get.toNamed('/cabinet'),
                    ),
                    const SizedBox(width: 24),
                    NavbarLink(
                      title: 'Doctor',
                      onTap: () => Get.toNamed('/docteur'),
                    ),
                  ],
                )
              else
                Theme(
                  data: Theme.of(context).copyWith(
                    popupMenuTheme: PopupMenuThemeData(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  child: PopupMenuButton<String>(
                    icon: const Icon(Icons.menu),
                    onSelected: (value) {
                      Get.toNamed('/$value');
                    },
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        value: 'pharmacie',
                        child: Text(
                          'Pharmacies',
                          style: TextStyle(
                            color: currentRoute == '/pharmacie'
                                ? const Color(0xFF47C3A4)
                                : Colors.grey[700],
                            fontWeight: currentRoute == '/pharmacie'
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: 'cabinet',
                        child: Text(
                          'Cabinet',
                          style: TextStyle(
                            color: currentRoute == '/cabinet'
                                ? const Color(0xFF47C3A4)
                                : Colors.grey[700],
                            fontWeight: currentRoute == '/cabinet'
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: 'docteur',
                        child: Text(
                          'Doctor',
                          style: TextStyle(
                            color: currentRoute == '/docteur'
                                ? const Color(0xFF47C3A4)
                                : Colors.grey[700],
                            fontWeight: currentRoute == '/docteur'
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
