import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_frontend/helpers/api_client.dart';
import 'package:flutter_frontend/helpers/api_endpoints.dart';
import 'package:flutter_frontend/models/car.dart';
import 'package:flutter_frontend/helpers/notification_service.dart';
import 'package:flutter_frontend/screens/dashboard_pages/home_components/car_card.dart';
import 'package:flutter_frontend/screens/dashboard_pages/home_components/maintenances_list.dart';

class HomePage extends StatefulWidget {
  final String selectedCarId;
  const HomePage(this.selectedCarId, {super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Car> _futureCar;

  Future<Car> fetchCar() async {
    return ApiClient.sendRequest(
            '${ApiEndpoints.carsEndpoint}/${widget.selectedCarId}',
            authorizedRequest: true)
        .then((data) {
      return Car.fromJson(data);
    }).catchError((error) {
      NotificationService.showNotification("$error", type: MessageType.error);
      throw error;
    });
  }

  void refreshCar() {
    setState(() {
      _futureCar = fetchCar();
    });
  }

  @override
  void initState() {
    super.initState();
    _futureCar = fetchCar();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
        future: _futureCar,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            log("Error loading home: ${snapshot.error}");
            return const Center(
              child: Text("Could not load car"),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final Car car = snapshot.data as Car;
          return Container(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: screenWidth > 768
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MaintenanceList(car, refreshCar),
                      if (screenWidth > 1000) const SizedBox(width: 50),
                      if (screenWidth > 768) CarCard(car)
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
