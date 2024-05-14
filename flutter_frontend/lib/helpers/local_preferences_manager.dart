import 'dart:developer';

import 'package:flutter_frontend/helpers/api_client.dart';
import 'package:flutter_frontend/helpers/api_endpoints.dart';
import 'package:flutter_frontend/models/car.dart';
import 'package:flutter_frontend/models/paged_results.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalPreferencesManager {
  static const String _selectedCarKey = 'selectedCarId';
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<String?> getSelectedCarId() async {
    var selectedCarId = await _storage.read(key: _selectedCarKey);

    if (selectedCarId != null) {
      return selectedCarId;
    }

    final car = await _fetchFirstCar();
    if (car != null) {
      await setSelectedCarId(car.id);
      return car.id;
    }

    return null;
  }

  static Future<void> setSelectedCarId(String carId) async {
    await _storage.write(key: _selectedCarKey, value: carId);
  }

  static void clearSelectedCarId() async {
    await _storage.delete(key: _selectedCarKey);
  }

  static Future<Car?> _fetchFirstCar() {
    return ApiClient.sendRequest(ApiEndpoints.carsEndpoint,
            authorizedRequest: true)
        .then((json) {
      return PagedResults<Car>.fromJson(json).data.firstOrNull;
    }).catchError((error) {
      log("Error fetching first car: $error");
      return null;
    });
  }
}
