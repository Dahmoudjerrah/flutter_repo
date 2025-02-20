import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getxapp/models/location.dart';
import 'package:getxapp/models/pharmacie_modele.dart';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PharmacyController extends GetxController {
  final RxBool showMap = false.obs;
  final RxString selectedWillaya = ''.obs;
  final RxString selectedMoughataa = ''.obs;
  final RxList<Pharmacy> allPharmacies = <Pharmacy>[].obs;
  final RxList<Pharmacy> filteredPharmacies = <Pharmacy>[].obs;
  final RxList<Pharmacy> nearestPharmacies = <Pharmacy>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<double?> userLat = Rx<double?>(null);
  final Rx<double?> userLng = Rx<double?>(null);

  final RxInt currentPage = 0.obs;
  final int pharmaciesPerPage = 5;
  final RxInt totalPages = 0.obs;

  // Use the same willayas and moughataasByWillaya from LocationController
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
    fetchPharmacies();
    getUserLocation();
  }

  List<Pharmacy> getPaginatedPharmacies() {
    final startIndex = currentPage.value * pharmaciesPerPage;
    final endIndex = startIndex + pharmaciesPerPage;
    if (nearestPharmacies.isEmpty) return [];
    return nearestPharmacies.sublist(
      startIndex,
      endIndex > nearestPharmacies.length ? nearestPharmacies.length : endIndex,
    );
  }

  void nextPage() {
    if (currentPage.value < totalPages.value - 1) {
      currentPage.value++;
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
    }
  }

  void updateTotalPages() {
    totalPages.value = (nearestPharmacies.length / pharmaciesPerPage).ceil();
  }

  Future<void> fetchPharmacies() async {
    try {
      isLoading(true);
      final response = await http
          .get(Uri.parse('http://127.0.0.1:8947/api/pharmacies/available'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        allPharmacies.value =
            jsonData.map((data) => Pharmacy.fromJson(data)).toList();
        updateFilteredPharmacies();
        updateNearestPharmacies();
      }
    } catch (e) {
      print('Erreur lors de la récupération des pharmacies: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> getUserLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      userLat.value = position.latitude;
      userLng.value = position.longitude;
      updateNearestPharmacies();
    } catch (e) {
      print('Erreur lors de la récupération de la position: $e');
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0;
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

  void updateNearestPharmacies() {
    if (userLat.value != null && userLng.value != null) {
      final pharmaciesWithDistance = allPharmacies.map((pharmacy) {
        pharmacy.distance = calculateDistance(
          userLat.value!,
          userLng.value!,
          pharmacy.latitude,
          pharmacy.longitude,
        );
        return pharmacy;
      }).toList();

      pharmaciesWithDistance
          .sort((a, b) => (a.distance ?? 0).compareTo(b.distance ?? 0));
      nearestPharmacies.value = pharmaciesWithDistance;
      updateTotalPages();
      currentPage.value = 0;
    }
  }

  void updateFilteredPharmacies() {
    filteredPharmacies.value = allPharmacies.where((pharmacy) {
      final willayaMatch =
          selectedWillaya.isEmpty || pharmacy.willaya == selectedWillaya.value;
      final moughataaMatch = selectedMoughataa.isEmpty ||
          pharmacy.moughataa == selectedMoughataa.value;
      return willayaMatch && moughataaMatch;
    }).toList();
  }

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

  void onWillayaChanged(String? value) {
    if (value != null) {
      selectedWillaya.value = value;
      selectedMoughataa.value = '';
      updateFilteredPharmacies();
    }
  }

  void onMoughataaChanged(String? value) {
    if (value != null) {
      selectedMoughataa.value = value;
      updateFilteredPharmacies();
    }
  }
}
