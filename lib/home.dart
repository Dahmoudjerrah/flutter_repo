import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Santé Locator'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
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
                    'Santé Locator',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.local_hospital),
              title: const Text('Cabinets Médicaux'),
              onTap: () => Get.toNamed('/cabinet'),
            ),
            ListTile(
              leading: const Icon(Icons.local_pharmacy),
              title: const Text('Pharmacies'),
              onTap: () => Get.toNamed('/pharmacie'),
            ),
            ListTile(
              leading: const Icon(Icons.medical_services),
              title: const Text('Docteurs'),
              onTap: () => Get.toNamed('/docteur'),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              height: 200,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue, Colors.lightBlue],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.health_and_safety,
                      size: 70,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Bienvenue sur Santé Locator',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Description Section
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'À Propos de Santé Locator',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Santé Locator est votre compagnon santé intelligent qui vous aide à localiser rapidement les établissements de santé les plus proches de vous. Notre application utilise votre position géographique pour vous fournir des informations précises et à jour sur :',
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 16),
                      BulletPoint(
                          text:
                              'Les pharmacies à proximité avec leurs horaires d\'ouverture'),
                      BulletPoint(
                          text:
                              'Les pharmacies de garde pendant les nuits et weekends'),
                      BulletPoint(
                          text: 'Les pharmacies les plus proches de vous'),
                      BulletPoint(
                          text:
                              'Les cabinets médicaux les plus proches de vous '),
                      BulletPoint(
                          text: 'Les docteurs spécialisés dans votre région'),
                      BulletPoint(
                          text:
                              'Les informations détaillées sur chaque doctor'),
                      SizedBox(height: 16),
                      Text(
                        'Notre service est disponible 24/7 et s\'adapte automatiquement pour n\'afficher que les pharmacies de garde pendant les heures non-ouvrables.',
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Services Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildServiceCard(
                      'Pharmacies',
                      Icons.local_pharmacy,
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildServiceCard(
                      'Cabinets',
                      Icons.local_hospital,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildServiceCard(
                      'Docteurs',
                      Icons.medical_services,
                      Colors.orange,
                    ),
                  ),
                ],
              ),
            ),

            // Features Section
            _buildFeatureCard(
              'Pharmacies de Garde',
              'Trouvez les pharmacies ouvertes la nuit et les weekends',
              Icons.nightlight_round,
            ),
            _buildFeatureCard(
              'Géolocalisation',
              'Découvrez les pharmacies est cabinets les plus proches de vous',
              Icons.location_on,
            ),
            _buildFeatureCard(
              'Docteurs Spécialisés',
              'Consultez les profils des médecins par spécialité',
              Icons.medical_services,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(String title, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(String title, String description, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class HomePage extends StatelessWidget {
//   final int totalPharmacies = 0; // Replace with your API data
//   final int totalClinics = 0; // Replace with your API data
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Santé Locator'),
//         centerTitle: true,
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             const DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircleAvatar(
//                     radius: 40,
//                     backgroundColor: Colors.white,
//                     child: Icon(Icons.local_hospital,
//                         size: 40, color: Colors.blue),
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     'Santé Locator',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 20,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             ListTile(
//               leading: const Icon(Icons.local_hospital),
//               title: const Text('Cabinets Médicaux'),
//               onTap: () => Get.toNamed('/cabinet'),
//             ),
//             ListTile(
//               leading: const Icon(Icons.local_pharmacy),
//               title: const Text('Pharmacies'),
//               onTap: () => Get.toNamed('/pharmacie'),
//             ),
//           ],
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Header Section
//             Container(
//               height: 200,
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [Colors.blue, Colors.lightBlue],
//                 ),
//               ),
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(
//                       Icons.health_and_safety,
//                       size: 70,
//                       color: Colors.white,
//                     ),
//                     const SizedBox(height: 10),
//                     const Text(
//                       'Bienvenue sur Santé Locator',
//                       style: TextStyle(
//                         fontSize: 24,
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             // Description Section
//             Container(
//               padding: const EdgeInsets.all(16.0),
//               child: Card(
//                 elevation: 4,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: const [
//                       Text(
//                         'À Propos de Santé Locator',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.blue,
//                         ),
//                       ),
//                       SizedBox(height: 16),
//                       Text(
//                         'Santé Locator est votre compagnon santé intelligent qui vous aide à localiser rapidement les établissements de santé les plus proches de vous. Notre application utilise votre position géographique pour vous fournir des informations précises et à jour sur :',
//                         style: TextStyle(
//                           fontSize: 16,
//                           height: 1.5,
//                         ),
//                       ),
//                       SizedBox(height: 16),
//                       BulletPoint(
//                           text:
//                               'Les pharmacies à proximité avec leurs horaires d\'ouverture'),
//                       BulletPoint(
//                           text:
//                               'Les pharmacies de garde pendant les nuits et weekends'),
//                       BulletPoint(
//                           text: 'Les cabinets médicaux les plus proches'),
//                       BulletPoint(
//                           text:
//                               'Les informations détaillées sur chaque établissement'),
//                       SizedBox(height: 16),
//                       Text(
//                         'Notre service est disponible 24/7 et s\'adapte automatiquement pour n\'afficher que les pharmacies de garde pendant les heures non-ouvrables.',
//                         style: TextStyle(
//                           fontSize: 16,
//                           height: 1.5,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//
//             // Stats Section
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: _buildStatsCard(
//                       'Pharmacies',
//                       totalPharmacies.toString(),
//                       Icons.local_pharmacy,
//                       Colors.green,
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: _buildStatsCard(
//                       'Cabinets',
//                       totalClinics.toString(),
//                       Icons.local_hospital,
//                       Colors.blue,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // Features Section
//             _buildFeatureCard(
//               'Pharmacies de Garde',
//               'Trouvez les pharmacies ouvertes la nuit et les weekends',
//               Icons.nightlight_round,
//             ),
//             _buildFeatureCard(
//               'Géolocalisation',
//               'Découvrez les établissements les plus proches de vous',
//               Icons.location_on,
//             ),
//             const SizedBox(height: 16),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStatsCard(
//       String title, String count, IconData icon, Color color) {
//     return Card(
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Icon(icon, size: 40, color: color),
//             const SizedBox(height: 8),
//             Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               count,
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: color,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFeatureCard(String title, String description, IconData icon) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Row(
//           children: [
//             Icon(icon, size: 40, color: Colors.blue),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     description,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// Bullet Point Widget
class BulletPoint extends StatelessWidget {
  final String text;

  const BulletPoint({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
