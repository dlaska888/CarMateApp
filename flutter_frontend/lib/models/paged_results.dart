import 'package:flutter_frontend/models/car.dart';
import 'package:flutter_frontend/models/maintenance.dart';

class PagedResults<T> {
  final List<T> data;
  final int totalPages;
  final int currentPage;
  final int perPage;
  final int totalItems;

  PagedResults({
    required this.data,
    required this.totalItems,
    required this.currentPage,
    required this.perPage,
  }) : totalPages = (totalItems / perPage).ceil();

  factory PagedResults.fromJson(Map<String, dynamic> json) {
    List<T> items = List<T>.from(json['data'].map((jsonItem) {
      if (T == Car) {
        return Car.fromJson(jsonItem as Map<String, dynamic>);
      } else if (T == Maintenance) {
        return Maintenance.fromJson(jsonItem as Map<String, dynamic>);
      } else {
        throw ArgumentError("Invalid type for PagedResults");
      }
    }));

    return PagedResults<T>(
      data: items,
      totalItems: json['totalItems'] as int,
      currentPage: json['currentPage'] as int,
      perPage: json['perPage'] as int,
    );
  }
}
