import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_frontend/helpers/api_client.dart';
import 'package:flutter_frontend/helpers/api_endpoints.dart';
import 'package:flutter_frontend/helpers/local_preferences_manager.dart';
import 'package:flutter_frontend/models/car.dart';
import 'package:flutter_frontend/models/paged_results.dart';
import 'package:flutter_frontend/helpers/notification_service.dart';
import 'package:flutter_frontend/screens/dashboard_pages/my_cars_components/car_tile.dart';
import 'package:flutter_frontend/screens/forms/cars/add_car.dart';
import 'package:flutter_frontend/screens/forms/form_modal.dart';

class MyCarsPage extends StatefulWidget {
  final String selectedCarId;
  const MyCarsPage(this.selectedCarId, {super.key});

  @override
  State<MyCarsPage> createState() => _MyCarsPageState();
}

class _MyCarsPageState extends State<MyCarsPage> {
  late Future<PagedResults<Car>> _futureCars;
  late String selectedCarId;

  Future<PagedResults<Car>> fetchCars() async {
    return ApiClient.sendRequest(ApiEndpoints.carsEndpoint,
            authorizedRequest: true)
        .then((data) async {
      return PagedResults<Car>.fromJson(data);
    }).catchError((error) {
      NotificationService.showNotification("$error", type: MessageType.error);
      throw error;
    });
  }

  void refreshCars() {
    setState(() {
      _futureCars = fetchCars();
    });
  }

  void changeSelectedCar(String carId) {
    LocalPreferencesManager.setSelectedCarId(carId);
    setState(() {
      selectedCarId = carId;
    });
  }

  @override
  void initState() {
    super.initState();
    _futureCars = fetchCars();
    selectedCarId = widget.selectedCarId;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PagedResults<Car>>(
      future: _futureCars,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          log("Error loading my_cars: ${snapshot.error}");
          return const Center(
            child: Text("Could not load cars"),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final carList = snapshot.data!.data
          ..sort((a, b) => a.id.compareTo(b.id));

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              FormModal(context).showModal(AddCarForm(refreshCars));
            },
            child: const Icon(Icons.add),
          ),
          body: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                      alignment: WrapAlignment.center,
                      children: carList.map((car) {
                        return GestureDetector(
                          onTap: () => changeSelectedCar(car.id),
                          child: CarTile(
                            car,
                            isCarSelected: car.id == selectedCarId,
                            key: Key(car.id),
                          ),
                        );
                      }).toList()),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
