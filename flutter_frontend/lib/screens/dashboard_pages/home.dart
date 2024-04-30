import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_frontend/api_client.dart';
import 'package:flutter_frontend/api_endpoints.dart';
import 'package:flutter_frontend/models/car.dart';
import 'package:flutter_frontend/notification_service.dart';
import 'package:flutter_frontend/screens/dashboard_pages/home_components/car_card.dart';
import 'package:flutter_frontend/screens/dashboard_pages/home_components/maintenances_list.dart';

class HomePage extends StatefulWidget {
  final String selectedCarId;
  const HomePage(this.selectedCarId, {super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Car _car;

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
    fetchCar().then((car) {
      setState(() {
        _car = car;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    refreshCar();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
        future: fetchCar(),
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

          _car = snapshot.data!;
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
                      MaintenanceList(_car, refreshCar),
                      if (screenWidth > 1000) const SizedBox(width: 50),
                      if (screenWidth > 768) CarCard(_car)
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
