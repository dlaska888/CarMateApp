class Maintenance {
  String id;
  String name;
  String? description;
  int? dueMileage;
  DateTime? dueDate;
  String? cost;

  Maintenance({
    required this.id,
    required this.name,
    this.description,
    this.dueMileage,
    this.dueDate,
    this.cost,
  });

  factory Maintenance.fromJson(Map<String, dynamic> json) {
    return Maintenance(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      dueMileage: json['dueMileage'],
      dueDate: DateTime.tryParse(json['dueDate'] ?? ''),
      cost: json['cost'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'dueMileage': dueMileage,
      'dueDate': dueDate?.toIso8601String(),
      'cost': cost,
    };
  }
}