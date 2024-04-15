class Car {
  final String? id;
  final String? name;
  final String? model;
  final String? brand;
  final double? displacement;
  final DateTime? productionDate;
  final int? mileage;
  final DateTime? purchaseDate;
  final String? plate;
  final String? vin;
  final List<dynamic> maintenances;

  Car({
    this.id,
    this.name,
    this.model,
    this.brand,
    this.displacement,
    this.productionDate,
    this.mileage,
    this.purchaseDate,
    this.plate,
    this.vin,
    required this.maintenances,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'],
      name: json['name'],
      model: json['model'],
      brand: json['brand'],
      displacement: json['displacement'].toDouble(),
      productionDate: DateTime.parse(json['productionDate']),
      mileage: json['mileage'],
      purchaseDate: DateTime.parse(json['purchaseDate']),
      plate: json['plate'],
      vin: json['VIN'],
      maintenances: json['maintenances'],
    );
  }
}