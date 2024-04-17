class Maintenance {
  final String id;
  final String name;
  final String? description;
  final int? dueMileage;
  final DateTime? dueDate;
  final double? cost;

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
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      cost: json['cost'],
    );
  }
}