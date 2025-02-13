import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getxapp/controllers/doctour_controller.dart';
import 'package:getxapp/views/doctourdetails_view.dart';

// class DoctorListView extends StatelessWidget {
//   final DoctorController controller = Get.put(DoctorController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Liste des Docteurs'),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Obx(() => DropdownButtonFormField<String>(
//                   value: controller.selectedSpeciality.value.isNotEmpty
//                       ? controller.selectedSpeciality.value
//                       : null,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: 'Sélectionnez une spécialité',
//                   ),
//                   items: [
//                     'CARDIOLOGIE',
//                     'DERMATOLOGIE',
//                     'PEDIATRIE',
//                     'GYNECOLOGIE',
//                     'NEUROLOGIE',
//                     'ONCOLOGIE',
//                     'ORTHOPEDIE',
//                     'OPHTALMOLOGIE',
//                     'RADIOLOGIE',
//                     'UROLOGIE'
//                   ].map((String speciality) {
//                     return DropdownMenuItem<String>(
//                       value: speciality,
//                       child: Text(speciality),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     if (value != null) {
//                       controller.filterBySpeciality(value);
//                     }
//                   },
//                 )),
//           ),
//           Expanded(
//             child: Obx(() {
//               if (controller.doctors.isEmpty) {
//                 return Center(child: CircularProgressIndicator());
//               }
//
//               return ListView.separated(
//                 itemCount: controller.paginatedDoctors.length,
//                 separatorBuilder: (context, index) => Divider(),
//                 itemBuilder: (context, index) {
//                   final doctor = controller.paginatedDoctors[index];
//                   return ListTile(
//                     leading: CircleAvatar(
//                       backgroundImage: AssetImage('assets/images/loc.png'),
//                     ),
//                     title: Text(doctor.name),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(doctor.speciality),
//                         Text(doctor.cabinet?.nom ?? 'Cabinet inconnu'),
//                       ],
//                     ),
//                     trailing: IconButton(
//                       icon: Icon(Icons.info_outline),
//                       onPressed: () {
//                         Get.to(() => DoctorDetailsView(doctorId: doctor.id));
//                       },
//                     ),
//                   );
//                 },
//               );
//             }),
//           ),
//           Obx(() => Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.arrow_back),
//                     onPressed: controller.currentPage.value > 1
//                         ? () => controller.previousPage()
//                         : null,
//                   ),
//                   Text(
//                     'Page ${controller.currentPage.value}',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.arrow_forward),
//                     onPressed:
//                         controller.currentPage.value * controller.pageSize <
//                                 controller.filteredDoctors.length
//                             ? () => controller.nextPage()
//                             : null,
//                   ),
//                 ],
//               )),
//         ],
//       ),
//     );
//   }
// }

class DoctorListView extends StatelessWidget {
  final DoctorController controller = Get.put(DoctorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Docteurs'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(() => DropdownButtonFormField<String>(
                  value: controller.selectedSpeciality.value.isNotEmpty
                      ? controller.selectedSpeciality.value
                      : null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Sélectionnez une spécialité',
                  ),
                  items: [
                    'CARDIOLOGIE',
                    'DERMATOLOGIE',
                    'PEDIATRIE',
                    'GYNECOLOGIE',
                    'NEUROLOGIE',
                    'ONCOLOGIE',
                    'ORTHOPEDIE',
                    'OPHTALMOLOGIE',
                    'RADIOLOGIE',
                    'UROLOGIE'
                  ].map((String speciality) {
                    return DropdownMenuItem<String>(
                      value: speciality,
                      child: Text(speciality),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.filterBySpeciality(value);
                    }
                  },
                )),
          ),
          Expanded(
            child: Obx(() {
              if (controller.doctors.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }

              return ListView.separated(
                itemCount: controller.paginatedDoctors.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  final doctor = controller.paginatedDoctors[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/loc.png'),
                    ),
                    title: Text(doctor.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(doctor.speciality),
                        if (doctor.cabinet != null) Text(doctor.cabinet!.nom),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.info_outline),
                      onPressed: () {
                        Get.to(() => DoctorDetailsView(doctorId: doctor.id));
                      },
                    ),
                  );
                },
              );
            }),
          ),
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: controller.currentPage.value > 1
                        ? () => controller.previousPage()
                        : null,
                  ),
                  Text(
                    'Page ${controller.currentPage.value}',
                    style: TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed:
                        controller.currentPage.value * controller.pageSize <
                                controller.filteredDoctors.length
                            ? () => controller.nextPage()
                            : null,
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
