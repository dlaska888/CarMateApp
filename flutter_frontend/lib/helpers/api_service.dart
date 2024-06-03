import 'dart:developer';

import 'package:flutter_frontend/helpers/api_client.dart';
import 'package:flutter_frontend/helpers/api_endpoints.dart';
import 'package:flutter_frontend/models/maintenance.dart';

class ApiService {
  Future<List<Maintenance>> fetchMaintenancesByDates(
      String carId, DateTime startDate, DateTime endDate) async {
    return ApiClient.sendRequest(
            '${ApiEndpoints.carsEndpoint}/$carId/maintenances/by-dates?startDate=$startDate&endDate=$endDate&withIntervals=true',
            authorizedRequest: true)
        .then((data) {
      return List<Maintenance>.from(data.map((m) => Maintenance.fromJson(m)));
    }).catchError((error) {
      log('$error');
      return <Maintenance>[];
    });
  }
}
