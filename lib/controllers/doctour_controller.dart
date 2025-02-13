import 'package:get/get.dart';
import 'package:getxapp/models/cabinet_model.dart';
import 'package:getxapp/models/doctour_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

// class DoctorController extends GetxController {
//   RxList<Doctor> doctors = <Doctor>[].obs;
//   RxList<Doctor> filteredDoctors = <Doctor>[].obs;
//   RxString selectedSpeciality = ''.obs;
//   RxInt currentPage = 1.obs;
//   final int pageSize = 10;
//   Map<int, Cabinet> cabinets = {};
//
//   @override
//   void onInit() {
//     super.onInit();
//     initializeData();
//   }
//
//   Future<void> initializeData() async {
//     await fetchCabinets();
//     await fetchDoctors();
//   }
//
//   Future<void> fetchCabinets() async {
//     try {
//       final response = await http.get(
//         Uri.parse('http://127.0.0.1:8947/api/cabinets'),
//       );
//
//       if (response.statusCode == 200) {
//         final List<dynamic> jsonList = json.decode(response.body);
//         cabinets = Map.fromEntries(
//           jsonList.map((json) {
//             final cabinet = Cabinet.fromJson(json);
//             return MapEntry(cabinet.id, cabinet);
//           }),
//         );
//       } else {
//         Get.snackbar('Error', 'Failed to load cabinets');
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'An error occurred while loading cabinets: $e');
//     }
//   }
//
//   Future<void> fetchDoctors() async {
//     try {
//       final response = await http.get(
//         Uri.parse('http://127.0.0.1:8947/api/doctors'),
//       );
//
//       if (response.statusCode == 200) {
//         final List<dynamic> jsonList = json.decode(response.body);
//         doctors.value = jsonList.where((json) => json != null).map((json) {
//           final doctor = Doctor.fromJson(json);
//           doctor.cabinet = cabinets[doctor.cabinetId];
//           return doctor;
//         }).toList();
//
//         applyFilter();
//       } else {
//         Get.snackbar('Error', 'Failed to load doctors');
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'An error occurred while loading doctors: $e');
//     }
//   }
//
//   void applyFilter() {
//     if (selectedSpeciality.isEmpty) {
//       filteredDoctors.value = doctors;
//     } else {
//       filteredDoctors.value = doctors
//           .where((doctor) => doctor.speciality == selectedSpeciality.value)
//           .toList();
//     }
//     currentPage.value = 1;
//   }
//
//   void filterBySpeciality(String speciality) {
//     selectedSpeciality.value = speciality;
//     applyFilter();
//   }
//
//   List<Doctor> get paginatedDoctors {
//     final startIndex = (currentPage.value - 1) * pageSize;
//     final endIndex = startIndex + pageSize;
//     return filteredDoctors.length > endIndex
//         ? filteredDoctors.sublist(startIndex, endIndex)
//         : filteredDoctors.sublist(startIndex);
//   }
//
//   void nextPage() {
//     if (currentPage.value * pageSize < filteredDoctors.length) {
//       currentPage.value++;
//     }
//   }
//
//   void previousPage() {
//     if (currentPage.value > 1) {
//       currentPage.value--;
//     }
//   }
// }
//
//
// class DoctorDetailsController extends GetxController {
//   Rx<Doctor?> doctor = Rx<Doctor?>(null);
//   RxBool isLoading = true.obs;
//   final DoctorController doctorController = Get.find<DoctorController>();
//
//   Future<void> fetchDoctorDetails(int doctorId) async {
//     try {
//       isLoading.value = true;
//
//       // D'abord, vérifier si le docteur existe déjà dans la liste principale
//       final existingDoctor =
//           doctorController.doctors.firstWhereOrNull((d) => d.id == doctorId);
//
//       if (existingDoctor != null) {
//         // Si le docteur existe déjà, l'utiliser directement
//         doctor.value = existingDoctor;
//         isLoading.value = false;
//         return;
//       }
//
//       // Sinon, faire l'appel API
//       final response = await http.get(
//         Uri.parse('https://api.dedahi.com/location/api/doctors/$doctorId'),
//       );
//
//       if (response.statusCode == 200) {
//         final jsonResponse = json.decode(response.body);
//         final newDoctor = Doctor.fromJson(jsonResponse);
//
//         // Récupérer le cabinet correspondant depuis le controller principal
//         if (doctorController.cabinets.containsKey(newDoctor.cabinetId)) {
//           newDoctor.cabinet = doctorController.cabinets[newDoctor.cabinetId];
//         } else {
//           // Si le cabinet n'existe pas encore, le récupérer
//           await fetchCabinetDetails(newDoctor.cabinetId);
//         }
//
//         doctor.value = newDoctor;
//       } else {
//         Get.snackbar('Error', 'Failed to load doctor details');
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'An error occurred: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> fetchCabinetDetails(int cabinetId) async {
//     try {
//       final response = await http.get(
//         Uri.parse('https://api.dedahi.com/location/api/cabinets/$cabinetId'),
//       );
//
//       if (response.statusCode == 200) {
//         final jsonResponse = json.decode(response.body);
//         final cabinet = Cabinet.fromJson(jsonResponse);
//
//         // Mettre à jour la map des cabinets dans le controller principal
//         doctorController.cabinets[cabinetId] = cabinet;
//
//         // Mettre à jour le cabinet du docteur courant
//         if (doctor.value != null) {
//           doctor.value!.cabinet = cabinet;
//         }
//       }
//     } catch (e) {
//       print('Error fetching cabinet details: $e');
//     }
//   }
//
//   Future<void> openMaps(Doctor doctor) async {
//     if (doctor.cabinet == null) {
//       Get.snackbar('Erreur', 'Informations du cabinet non disponibles');
//       return;
//     }
//
//     final Uri mapUrl = Uri.parse(
//       'https://www.openstreetmap.org/dir?route=;${doctor.cabinet!.latitude},${doctor.cabinet!.longitude}',
//     );
//
//     try {
//       if (await canLaunchUrl(mapUrl)) {
//         await launchUrl(mapUrl, mode: LaunchMode.externalApplication);
//       } else {
//         Get.snackbar('Erreur', 'Impossible d\'ouvrir la carte');
//       }
//     } catch (e) {
//       Get.snackbar('Erreur', 'Problème lors de l\'ouverture de la carte');
//     }
//   }
// }
class DoctorController extends GetxController {
  RxList<Doctor> doctors = <Doctor>[].obs;
  RxList<Doctor> filteredDoctors = <Doctor>[].obs;
  RxString selectedSpeciality = ''.obs;
  RxInt currentPage = 1.obs;
  final int pageSize = 10;
  Map<int, Cabinet> cabinets = {};

  @override
  void onInit() {
    super.onInit();
    initializeData();
  }

  Future<void> initializeData() async {
    await fetchDoctors();
    await fetchCabinetsForDoctors();
  }

  Future<void> fetchDoctors() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8947/api/doctors'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        doctors.value = jsonList
            .where((json) => json != null)
            .map((json) => Doctor.fromJson(json))
            .toList();
        applyFilter();
      } else {
        Get.snackbar('Error', 'Failed to load doctors');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while loading doctors: $e');
    }
  }

  Future<void> fetchCabinetsForDoctors() async {
    final cabinetIds = doctors
        .map((doctor) => doctor.cabinetId)
        .toSet()
        .where((id) => id > 0)
        .toList();

    for (var id in cabinetIds) {
      try {
        final response = await http.get(
          Uri.parse('http://127.0.0.1:8947/api/cabinets/$id'),
        );

        if (response.statusCode == 200) {
          final cabinet = Cabinet.fromJson(json.decode(response.body));
          cabinets[id] = cabinet;

          doctors.where((doctor) => doctor.cabinetId == id).forEach((doctor) {
            doctor.cabinet = cabinet;
          });
        }
      } catch (e) {
        print('Error fetching cabinet $id: $e');
      }
    }
    doctors.refresh();
  }

  void applyFilter() {
    if (selectedSpeciality.isEmpty) {
      filteredDoctors.value = doctors;
    } else {
      filteredDoctors.value = doctors
          .where((doctor) => doctor.speciality == selectedSpeciality.value)
          .toList();
    }
    currentPage.value = 1;
  }

  void filterBySpeciality(String speciality) {
    selectedSpeciality.value = speciality;
    applyFilter();
  }

  List<Doctor> get paginatedDoctors {
    final startIndex = (currentPage.value - 1) * pageSize;
    final endIndex = startIndex + pageSize;
    return filteredDoctors.length > endIndex
        ? filteredDoctors.sublist(startIndex, endIndex)
        : filteredDoctors.sublist(startIndex);
  }

  void nextPage() {
    if (currentPage.value * pageSize < filteredDoctors.length) {
      currentPage.value++;
    }
  }

  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
    }
  }
}

// controllers/doctor_details_controller.dart
class DoctorDetailsController extends GetxController {
  Rx<Doctor?> doctor = Rx<Doctor?>(null);
  RxBool isLoading = true.obs;
  final DoctorController doctorController = Get.find<DoctorController>();

  Future<void> fetchDoctorDetails(int doctorId) async {
    try {
      isLoading.value = true;

      final existingDoctor =
          doctorController.doctors.firstWhereOrNull((d) => d.id == doctorId);

      if (existingDoctor != null) {
        doctor.value = existingDoctor;
        isLoading.value = false;
        return;
      }

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8947/api/doctors/$doctorId'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final newDoctor = Doctor.fromJson(jsonResponse);

        if (doctorController.cabinets.containsKey(newDoctor.cabinetId)) {
          newDoctor.cabinet = doctorController.cabinets[newDoctor.cabinetId];
        } else {
          await fetchCabinetDetails(newDoctor.cabinetId);
        }

        doctor.value = newDoctor;
      } else {
        Get.snackbar('Error', 'Failed to load doctor details');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCabinetDetails(int cabinetId) async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8947/api/cabinets/$cabinetId'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final cabinet = Cabinet.fromJson(jsonResponse);
        doctorController.cabinets[cabinetId] = cabinet;

        if (doctor.value != null) {
          doctor.value!.cabinet = cabinet;
          doctor.refresh();
        }
      }
    } catch (e) {
      print('Error fetching cabinet details: $e');
    }
  }

  Future<void> openMaps(Doctor doctor) async {
    if (doctor.cabinet == null) {
      Get.snackbar('Erreur', 'Informations du cabinet non disponibles');
      return;
    }

    final Uri mapUrl = Uri.parse(
      'https://www.openstreetmap.org/dir?route=;${doctor.cabinet!.latitude},${doctor.cabinet!.longitude}',
    );

    try {
      if (await canLaunchUrl(mapUrl)) {
        await launchUrl(mapUrl, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar('Erreur', 'Impossible d\'ouvrir la carte');
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Problème lors de l\'ouverture de la carte');
    }
  }
}
