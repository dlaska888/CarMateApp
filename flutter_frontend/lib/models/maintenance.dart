class Maintenance {
  String? id;
  String? name;
  String? description;
  int? dueMileage;
  DateTime? dueDate;
  double? cost;

  Maintenance({
    this.id,
    this.name,
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