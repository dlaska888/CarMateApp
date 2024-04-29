import 'package:flutter_frontend/models/maintenance.dart';

class Car {
  String id;
  String name;
  String? model;
  String? brand;
  double? displacement;
  DateTime? productionDate;
  int? mileage;
  DateTime? purchaseDate;
  String? plate;
  String? vin;
  List<Maintenance> maintenances = [];

  Car({
    required this.id,
    required this.name,
    this.model,
    this.brand,
    this.displacement,
    this.productionDate,
    this.mileage,
    this.purchaseDate,
    this.plate,
    this.vin,
    this.maintenances = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'model': model,
      'brand': brand,
      'displacement': displacement,
      'productionDate': productionDate?.toIso8601String(),
      'mileage': mileage,
      'purchaseDate': purchaseDate?.toIso8601String(),
      'plate': plate,
      'vin': vin
      // maintenances are not included in the JSON
    };
  }

  factory Car.fromJson(Map<String, dynamic> json) {
    final maintenances =
        List<Maintenance>.from(json['maintenances'].map((maintenance) {
      return Maintenance.fromJson(maintenance);
    }));

    return Car(
      id: json['id'],
      name: json['name'],
      model: json['model'],
      brand: json['brand'],
      displacement: json['displacement'],
      productionDate: DateTime.tryParse(json['productionDate'] ?? ''),
      mileage: json['mileage'],
      purchaseDate: DateTime.tryParse(json['purchaseDate'] ?? ''),
      plate: json['plate'],
      vin: json['vin'],
      maintenances: maintenances,
    );
  }
}
