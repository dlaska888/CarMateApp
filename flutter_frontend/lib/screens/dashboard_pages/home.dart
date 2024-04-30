import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_frontend/api_client.dart';
import 'package:flutter_frontend/api_endpoints.dart';
import 'package:flutter_frontend/models/car.dart';
import 'package:flutter_frontend/notification_service.dart';
import 'package:flutter_frontend/screens/dashboard_pages/cars_components/car_field_card.dart';
import 'package:flutter_frontend/screens/dashboard_pages/cars_components/maintenance_card.dart';
import 'package:flutter_frontend/screens/forms/form_modal.dart';
import 'package:flutter_frontend/screens/forms/maintenances/add_maintenance.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final Car selectedCar;
  const HomePage(this.selectedCar, {super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Car _car;

  Future<Car> fetchCar() async {
    return ApiClient.sendRequest('${ApiEndpoints.carsEndpoint}/${_car.id}',
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
    _car = widget.selectedCar;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
        future: fetchCar(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            log("Error loading home: ${snapshot.error}");
            return const Center(
              child: Text("Could not load car"),
            );
          }

          _car = snapshot.data!;
          final maintenanceList = snapshot.data!.maintenances
            ..sort((a, b) => a.id.compareTo(b.id));

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
                      Flexible(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                      color: Colors
                                          .white, // Set background color (optional)
                                      borderRadius: BorderRadius.circular(
                                          10.0), // Add rounded corners (optional)
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey
                                              .withOpacity(0.5), // Shadow color
                                          spreadRadius:
                                              2.0, // Adjusts shadow spread (optional)
                                          blurRadius:
                                              4.0, // Adjusts shadow blur (optional)
                                          offset: const Offset(2.0,
                                              2.0), // Sets shadow offset (optional)
                                        ),
                                      ],
                                    ),
                                    margin: const EdgeInsets.all(8.0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Icon(
                                                Icons.directions_car,
                                                color: primary,
                                                size: 40.0,
                                              )
                                            ],
                                          ),
                                          const Text(
                                            "Maintenance",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 24.0,
                                                      vertical: 16.0),
                                              backgroundColor: Colors.white,
                                              foregroundColor: Colors.black,
                                              textStyle: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onPressed: () => FormModal(context)
                                                .showModal(AddMaintenanceForm(
                                                    _car, refreshCar)),
                                            child: const Text("Add"),
                                          )
                                        ],
                                      ),
                                    )),
                                Column(
                                    children: maintenanceList.map((m) {
                                  return MaintenanceCard(
                                    m,
                                    _car,
                                    key: Key(m.id),
                                  );
                                }).toList())
                              ]),
                        ),
                      ),
                      if (screenWidth > 1000) const SizedBox(width: 50),
                      if (screenWidth > 768)
                        Flexible(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 500),
                            child: Column(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                      color: Colors
                                          .white, // Set background color (optional)
                                      borderRadius: BorderRadius.circular(
                                          10.0), // Add rounded corners (optional)
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey
                                              .withOpacity(0.5), // Shadow color
                                          spreadRadius:
                                              2.0, // Adjusts shadow spread (optional)
                                          blurRadius:
                                              4.0, // Adjusts shadow blur (optional)
                                          offset: const Offset(2.0,
                                              2.0), // Sets shadow offset (optional)
                                        ),
                                      ],
                                    ),
                                    margin: const EdgeInsets.all(8.0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Icon(
                                                Icons.directions_car,
                                                color: primary,
                                                size: 40.0,
                                              )
                                            ],
                                          ),
                                          Text(
                                            _car.name,
                                            style: const TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 24.0,
                                                      vertical: 16.0),
                                              backgroundColor: Colors.white,
                                              foregroundColor: Colors.black,
                                              textStyle: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onPressed: () {},
                                            child: const Text("Add Photo"),
                                          )
                                        ],
                                      ),
                                    )
                                    // ... other Container properties (width, height, child)
                                    ),
                                Container(
                                    decoration: BoxDecoration(
                                      color: Colors
                                          .white, // Set background color (optional)
                                      borderRadius: BorderRadius.circular(
                                          20.0), // Add rounded corners (optional)
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey
                                              .withOpacity(0.5), // Shadow color
                                          spreadRadius:
                                              2.0, // Adjusts shadow spread (optional)
                                          blurRadius:
                                              4.0, // Adjusts shadow blur (optional)
                                          offset: const Offset(2.0,
                                              2.0), // Sets shadow offset (optional)
                                        ),
                                      ],
                                    ),
                                    margin: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      "images/car1.jpg",
                                      width: 500,
                                    )
                                    // ... other Container properties (width, height, child)
                                    ),
                                Wrap(
                                  alignment: WrapAlignment.spaceEvenly,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    if (_car.displacement != null)
                                      CarFieldCard(
                                          "Engine displacement",
                                          _car.displacement.toString(),
                                          Icons.agriculture_outlined),
                                    if (_car.mileage != null)
                                      CarFieldCard(
                                          "Milage",
                                          _car.mileage.toString(),
                                          Icons.directions_car),
                                    if (_car.productionDate != null)
                                      CarFieldCard(
                                          "Production date",
                                          DateFormat('yyyy-MM-dd')
                                              .format(_car.productionDate!),
                                          Icons.access_time_filled),
                                    if (_car.purchaseDate != null)
                                      CarFieldCard(
                                          "Purchase date",
                                          DateFormat('yyyy-MM-dd')
                                              .format(_car.purchaseDate!),
                                          Icons.shopping_cart),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
