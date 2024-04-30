import 'package:flutter/material.dart';
import 'package:flutter_frontend/models/car.dart';
import 'package:flutter_frontend/screens/dashboard_pages/home_components/maintenance_card.dart';
import 'package:flutter_frontend/screens/forms/form_modal.dart';
import 'package:flutter_frontend/screens/forms/maintenances/add_maintenance.dart';

class MaintenanceList extends StatelessWidget {
  final Car car;
  final Function refreshCar;
  const MaintenanceList(this.car, this.refreshCar, {super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return Flexible(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Set background color (optional)
                    borderRadius: BorderRadius.circular(
                        10.0), // Add rounded corners (optional)
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Shadow color
                        spreadRadius: 2.0, // Adjusts shadow spread (optional)
                        blurRadius: 4.0, // Adjusts shadow blur (optional)
                        offset: const Offset(
                            2.0, 2.0), // Sets shadow offset (optional)
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Icon(
                              Icons.car_repair,
                              color: primary,
                              size: 40.0,
                            )
                          ],
                        ),
                        const Text(
                          "Maintenances",
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 16.0),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            textStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () => FormModal(context)
                              .showModal(AddMaintenanceForm(car, refreshCar)),
                          child: const Text("Add"),
                        )
                      ],
                    ),
                  )),
              if (car.maintenances.isEmpty)
                Container(
                  margin: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => FormModal(context)
                        .showModal(AddMaintenanceForm(car, refreshCar)),
                    child: const Text("Add first maintenance"),
                  ),
                )
              else
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 500),
                  child: ClipRRect(
                    child: SingleChildScrollView(
                      child: Column(
                          children: car.maintenances.map((m) {
                        return MaintenanceCard(
                          m,
                          car,
                          key: Key(m.id),
                        );
                      }).toList()),
                    ),
                  ),
                )
            ]),
      ),
    );
  }
}
