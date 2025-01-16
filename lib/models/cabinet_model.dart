import 'dart:convert';

class Cabinet {
  final int id;
  final String nom;
  final String willaya;
  final String moughataa;
  final double longitude;
  final double latitude;
  double? distance;

  Cabinet({
    required this.id,
    required this.nom,
    required this.willaya,
    required this.moughataa,
    required this.longitude,
    required this.latitude,
    this.distance,
  });

  factory Cabinet.fromJson(Map<String, dynamic> json) {
    return Cabinet(
      id: json['id'] as int,
      // nom: json['nom'] as String,
      nom: utf8.decode(latin1.encode(json['nom'])),
      willaya: json['willaya'] as String,
      moughataa: json['moughataa'] as String,
      longitude: json['longitude'].toDouble(),
      latitude: json['latitude'].toDouble(),
    );
  }
}
