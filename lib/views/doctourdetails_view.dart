import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:getxapp/controllers/doctour_controller.dart';
import 'package:getxapp/models/cabinet_model.dart';
import 'package:getxapp/models/doctour_model.dart';
import 'package:url_launcher/url_launcher.dart';

// class DoctorDetailsView extends StatelessWidget {
//   final int doctorId;
//   final DoctorDetailsController controller;
//
//   DoctorDetailsView({required this.doctorId})
//       : controller = Get.put(DoctorDetailsController()) {
//     controller.fetchDoctorDetails(doctorId);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Détails du Docteur'),
//         centerTitle: true,
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return Center(child: CircularProgressIndicator());
//         }
//
//         final doctor = controller.doctor.value;
//         if (doctor == null) {
//           return Center(child: Text('Impossible de charger les détails'));
//         }
//
//         return SingleChildScrollView(
//           padding: EdgeInsets.all(8),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Section Profil Docteur
//               Card(
//                 elevation: 4,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       CircleAvatar(
//                         radius: 50,
//                         backgroundImage: AssetImage('assets/images/loc.png'),
//                         backgroundColor: Colors.grey[200],
//                       ),
//                       SizedBox(height: 16),
//                       Text(
//                         doctor.name,
//                         style:
//                             Theme.of(context).textTheme.headlineSmall?.copyWith(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                         textAlign: TextAlign.center,
//                       ),
//                       SizedBox(height: 8),
//                       Container(
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                         decoration: BoxDecoration(
//                           color:
//                               Theme.of(context).primaryColor.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           doctor.speciality,
//                           style:
//                               Theme.of(context).textTheme.titleMedium?.copyWith(
//                                     color: Theme.of(context).primaryColor,
//                                   ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 16),
//
//               // Section Cabinet
//               Card(
//                 elevation: 4,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(Icons.location_on,
//                               color: Theme.of(context).primaryColor),
//                           SizedBox(width: 8),
//                           Text(
//                             'Informations du Cabinet',
//                             style: Theme.of(context).textTheme.titleLarge,
//                           ),
//                         ],
//                       ),
//                       Divider(height: 24),
//                       if (doctor.cabinet != null) ...[
//                         ListTile(
//                           contentPadding: EdgeInsets.zero,
//                           title: Text(
//                             doctor.cabinet!.nom,
//                             style: Theme.of(context).textTheme.titleMedium,
//                           ),
//                           subtitle: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               SizedBox(height: 4),
//                               Text('Wilaya: ${doctor.cabinet!.willaya}'),
//                               Text('Moughataa: ${doctor.cabinet!.moughataa}'),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: 16),
//                         ElevatedButton.icon(
//                           onPressed: () => controller.openMaps(doctor),
//                           icon: Icon(Icons.map),
//                           label: Text('Voir sur la carte'),
//                           style: ElevatedButton.styleFrom(
//                             minimumSize: Size(double.infinity, 45),
//                           ),
//                         ),
//                       ] else
//                         Text(
//                           'Informations du cabinet non disponibles',
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 16),
//
//               // Section Horaires
//               Card(
//                 elevation: 4,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(Icons.schedule,
//                               color: Theme.of(context).primaryColor),
//                           SizedBox(width: 8),
//                           Text(
//                             'Horaires de Consultation',
//                             style: Theme.of(context).textTheme.titleLarge,
//                           ),
//                         ],
//                       ),
//                       Divider(height: 24),
//                       if (doctor.schedule.isNotEmpty)
//                         ...doctor.schedule.entries.map(
//                           (entry) => Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 8.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   entry.key,
//                                   style:
//                                       Theme.of(context).textTheme.titleMedium,
//                                 ),
//                                 Text(
//                                   entry.value,
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .bodyLarge
//                                       ?.copyWith(
//                                         color: Theme.of(context).primaryColor,
//                                       ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         )
//                       else
//                         Text(
//                           'Horaires non disponibles',
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 16),
//
//               // Section Contact (optionnel)
//               Card(
//                 elevation: 4,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(Icons.contact_phone,
//                               color: Theme.of(context).primaryColor),
//                           SizedBox(width: 8),
//                           Text(
//                             'Contact',
//                             style: Theme.of(context).textTheme.titleLarge,
//                           ),
//                         ],
//                       ),
//                       Divider(height: 24),
//                       ElevatedButton.icon(
//                         onPressed: () {
//                           // Implémenter la logique de prise de rendez-vous
//                           Get.snackbar(
//                             'Information',
//                             'La prise de rendez-vous sera bientôt disponible',
//                             backgroundColor: Colors.green[100],
//                           );
//                         },
//                         icon: Icon(Icons.calendar_today),
//                         label: Text('Prendre un rendez-vous'),
//                         style: ElevatedButton.styleFrom(
//                           minimumSize: Size(double.infinity, 45),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 24),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }
///////////////////////////////////////////////
// class DoctorDetailsView extends StatelessWidget {
//   final int doctorId;
//   final DoctorDetailsController controller;
//
//   DoctorDetailsView({required this.doctorId})
//       : controller = Get.put(DoctorDetailsController()) {
//     controller.fetchDoctorDetails(doctorId);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Détails du Docteur'),
//         centerTitle: true,
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         final doctor = controller.doctor.value;
//         if (doctor == null) {
//           return const Center(child: Text('Impossible de charger les détails'));
//         }
//
//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Section Profil Docteur
//               _buildDoctorProfileCard(context, doctor),
//               const SizedBox(height: 16),
//
//               // Section Cabinet
//               _buildCabinetCard(context, doctor),
//               const SizedBox(height: 16),
//
//               // Section Horaires
//               _buildScheduleCard(context, doctor),
//               const SizedBox(height: 16),
//
//               // Section Contact/RDV
//               _buildContactCard(context),
//               const SizedBox(height: 24),
//             ],
//           ),
//         );
//       }),
//     );
//   }
//
//   Widget _buildDoctorProfileCard(BuildContext context, Doctor doctor) {
//     return Card(
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const CircleAvatar(
//               radius: 50,
//               backgroundImage: AssetImage('assets/images/loc.png'),
//               backgroundColor: Colors.grey,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               doctor.name,
//               style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                     fontWeight: FontWeight.bold,
//                   ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 8),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 color: Theme.of(context).primaryColor.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Text(
//                 doctor.speciality,
//                 style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                       color: Theme.of(context).primaryColor,
//                     ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCabinetCard(BuildContext context, Doctor doctor) {
//     return Card(
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(Icons.location_on, color: Theme.of(context).primaryColor),
//                 const SizedBox(width: 8),
//                 Text(
//                   'Informations du Cabinet',
//                   style: Theme.of(context).textTheme.titleLarge,
//                 ),
//               ],
//             ),
//             const Divider(height: 24),
//             if (doctor.cabinet != null) ...[
//               ListTile(
//                 contentPadding: EdgeInsets.zero,
//                 title: Text(
//                   doctor.cabinet!.nom,
//                   style: Theme.of(context).textTheme.titleMedium,
//                 ),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 4),
//                     Text('Wilaya: ${doctor.cabinet!.willaya}'),
//                     Text('Moughataa: ${doctor.cabinet!.moughataa}'),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton.icon(
//                 onPressed: () => controller.openMaps(doctor),
//                 icon: const Icon(Icons.map),
//                 label: const Text('Voir sur la carte'),
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: const Size(double.infinity, 45),
//                 ),
//               ),
//             ] else
//               const Text(
//                 'Informations du cabinet non disponibles',
//                 style: TextStyle(color: Colors.grey),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildScheduleCard(BuildContext context, Doctor doctor) {
//     return Card(
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(Icons.schedule, color: Theme.of(context).primaryColor),
//                 const SizedBox(width: 8),
//                 Text(
//                   'Horaires de Consultation',
//                   style: Theme.of(context).textTheme.titleLarge,
//                 ),
//               ],
//             ),
//             const Divider(height: 24),
//             if (doctor.schedules.isNotEmpty)
//               ...doctor.formattedSchedules.entries.map(
//                 (entry) => Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         entry.key,
//                         style: Theme.of(context).textTheme.titleMedium,
//                       ),
//                       Text(
//                         entry.value,
//                         style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                               color: Theme.of(context).primaryColor,
//                             ),
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//             else
//               const Text(
//                 'Horaires non disponibles',
//                 style: TextStyle(color: Colors.grey),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildContactCard(BuildContext context) {
//     return Card(
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(Icons.contact_phone,
//                     color: Theme.of(context).primaryColor),
//                 const SizedBox(width: 8),
//                 Text(
//                   'Contact',
//                   style: Theme.of(context).textTheme.titleLarge,
//                 ),
//               ],
//             ),
//             const Divider(height: 24),
//             ElevatedButton.icon(
//               onPressed: () {
//                 Get.snackbar(
//                   'Information',
//                   'La prise de rendez-vous sera bientôt disponible',
//                   backgroundColor: Colors.green[100],
//                 );
//               },
//               icon: const Icon(Icons.calendar_today),
//               label: const Text('Prendre un rendez-vous'),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size(double.infinity, 45),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
class DoctorDetailsView extends StatelessWidget {
  final int doctorId;
  final DoctorDetailsController controller;

  DoctorDetailsView({Key? key, required this.doctorId})
      : controller = Get.put(DoctorDetailsController()),
        super(key: key) {
    controller.fetchDoctorDetails(doctorId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du Docteur'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final doctor = controller.doctor.value;
        if (doctor == null) {
          return const Center(child: Text('Impossible de charger les détails'));
        }

        // Grouper les horaires par cabinet
        Map<int, List<Schedule>> schedulesByCabinet = {};
        for (var schedule in doctor.schedules) {
          if (!schedulesByCabinet.containsKey(schedule.cabinetId)) {
            schedulesByCabinet[schedule.cabinetId] = [];
          }
          schedulesByCabinet[schedule.cabinetId]!.add(schedule);
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDoctorProfileCard(context, doctor),
              const SizedBox(height: 16),

              // Une section pour chaque cabinet
              ...schedulesByCabinet.entries.map((entry) {
                final cabinetId = entry.key;
                final schedules = entry.value;
                final cabinet = controller.doctorController.cabinets[cabinetId];
                return Column(
                  children: [
                    _buildCabinetCard(context, cabinet, schedules),
                    const SizedBox(height: 16),
                  ],
                );
              }).toList(),

              _buildContactCard(context),
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDoctorProfileCard(BuildContext context, Doctor doctor) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade100,
              ),
              child: Center(
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              doctor.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                doctor.speciality,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCabinetCard(
    BuildContext context,
    Cabinet? cabinet,
    List<Schedule> schedules,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Theme.of(context).primaryColor,
                  size: 28,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    cabinet?.nom ?? 'Cabinet inconnu',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (cabinet != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wilaya: ${cabinet.willaya}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Moughataa: ${cabinet.moughataa}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _openMaps(cabinet),
                icon: const Icon(Icons.map),
                label: const Text('Voir sur la carte'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
            const Divider(height: 32),
            const Text(
              'Horaires de Consultation',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...schedules
                .map((schedule) => Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            schedule.dayOfWeek,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${schedule.startTime} - ${schedule.endTime}',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.contact_phone,
                  color: Theme.of(context).primaryColor,
                  size: 28,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Contact',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Get.snackbar(
                  'Information',
                  'La prise de rendez-vous sera bientôt disponible',
                  backgroundColor: Colors.green.shade100,
                  colorText: Colors.black87,
                  duration: const Duration(seconds: 3),
                );
              },
              icon: const Icon(Icons.calendar_today),
              label: const Text(
                'Prendre un rendez-vous',
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openMaps(Cabinet cabinet) async {
    final Uri mapUrl = Uri.parse(
      'https://www.openstreetmap.org/dir?route=;${cabinet.latitude},${cabinet.longitude}',
    );

    try {
      if (await canLaunchUrl(mapUrl)) {
        await launchUrl(mapUrl, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Erreur',
          'Impossible d\'ouvrir la carte',
          backgroundColor: Colors.red.shade100,
          colorText: Colors.black87,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Problème lors de l\'ouverture de la carte',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black87,
      );
    }
  }
}
