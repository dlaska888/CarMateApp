import 'package:flutter_frontend/helpers/datime_helper.dart';
import 'package:iso8601_duration/iso8601_duration.dart';

class Maintenance {
  String id;
  String name;
  String? description;
  int? dueMileage;
  int? mileageInterval;
  DateTime? dueDate;
  ISODuration? dateInterval;
  String? cost;

  Maintenance({
    required this.id,
    required this.name,
    this.description,
    this.dueMileage,
    this.mileageInterval,
    this.dueDate,
    this.dateInterval,
    this.cost,
  });

  factory Maintenance.fromJson(Map<String, dynamic> json) {
    return Maintenance(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      dueMileage: json['dueMileage'],
      mileageInterval: json['mileageInterval'],
      dueDate: DateTime.tryParse(json['dueDate'] ?? ''),
      dateInterval: json['dateInterval'] != null
          ? ISODurationConverter()
              .parseString(isoDurationString: json['dateInterval'])
          : null,
      cost: json['cost'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'dueMileage': dueMileage,
      'mileageInterval': mileageInterval,
      'dueDate': dueDate?.toIso8601String(),
      'dateInterval': dateInterval != null
          ? DateTimeHelper.convertToISO8601(dateInterval!)
          : null,
      'cost': cost,
    };
  }
}
