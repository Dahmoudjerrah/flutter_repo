import 'package:getxapp/models/cabinet_model.dart';
import 'dart:convert';

// class Doctor {
//   final int id;
//   final String name;
//   final String speciality;
//   final int cabinetId;
//   final Map<String, String> schedule;
//   Cabinet? cabinet;
//
//   Doctor({
//     required this.id,
//     required this.name,
//     required this.speciality,
//     required this.cabinetId,
//     this.cabinet,
//     this.schedule = const {},
//   });
//
//   factory Doctor.fromJson(Map<String, dynamic>? json) {
//     if (json == null) {
//       throw ArgumentError('JSON cannot be null');
//     }
//
//     return Doctor(
//       id: json['id'] ?? 0,
//       name: utf8.decode(latin1.encode(json['name'] ?? 'Unknown')),
//       speciality: json['speciality'] ?? 'Unspecified',
//       cabinetId: json['cabinetId'] ?? 0,
//       schedule: json['schedule'] != null
//           ? Map<String, String>.from(json['schedule'])
//           : {},
//     );
//   }
// }
class Schedule {
  final int id;
  final int cabinetId;
  final String dayOfWeek;
  final String startTime;
  final String endTime;

  Schedule({
    required this.id,
    required this.cabinetId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      cabinetId: json['cabinetId'],
      dayOfWeek: json['dayOfWeek'],
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }
}

class Doctor {
  final int id;
  final String name;
  final String speciality;
  final List<Schedule> schedules;
  Cabinet? cabinet;

  Doctor({
    required this.id,
    required this.name,
    required this.speciality,
    required this.schedules,
    this.cabinet,
  });

  int get cabinetId => schedules.isNotEmpty ? schedules.first.cabinetId : 0;

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      name: json['name'],
      speciality: json['speciality'],
      schedules: (json['schedules'] as List)
          .map((schedule) => Schedule.fromJson(schedule))
          .toList(),
    );
  }

  Map<String, String> get formattedSchedules {
    Map<String, String> result = {};
    for (var schedule in schedules) {
      result[schedule.dayOfWeek] =
          '${schedule.startTime} - ${schedule.endTime}';
    }
    return result;
  }
}
