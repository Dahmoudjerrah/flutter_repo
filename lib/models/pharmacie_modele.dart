import 'dart:convert';

class Pharmacy {
  final int id;
  final String name;
  final String willaya;
  final String moughataa;
  final double longitude;
  final double latitude;
  final bool openTonight;
  double? distance;

  Pharmacy({
    required this.id,
    required this.name,
    required this.willaya,
    required this.moughataa,
    required this.longitude,
    required this.latitude,
    required this.openTonight,
    this.distance,
  });

  factory Pharmacy.fromJson(Map<String, dynamic> json) {
    return Pharmacy(
      id: json['id'] as int,
      name: utf8.decode(latin1.encode(json['name'])),
      willaya: json['willaya'] as String,
      moughataa: json['moughataa'] as String,
      longitude: json['longitude'].toDouble(),
      latitude: json['latitude'].toDouble(),
      openTonight: json['openTonight'] as bool,
    );
  }
}
