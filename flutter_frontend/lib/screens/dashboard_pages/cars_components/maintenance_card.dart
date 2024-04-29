import 'package:flutter/material.dart';
import 'package:flutter_frontend/models/maintenance.dart';
import 'package:intl/intl.dart';

class MaintenanceCard extends StatefulWidget {
  final Maintenance maintenance;
  const MaintenanceCard(this.maintenance, {super.key});

  @override
  State<MaintenanceCard> createState() => _MaintenanceCardState();
}

class _MaintenanceCardState extends State<MaintenanceCard> {
  late Maintenance _maintenance;
  bool isMaintenanceDeleted = false;

  @override
  void initState() {
    _maintenance = widget.maintenance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    if (isMaintenanceDeleted) {
      return const SizedBox();
    }
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow color
              spreadRadius: 2.0, // Adjusts shadow spread (optional)
              blurRadius: 4.0, // Adjusts shadow blur (optional)
              offset: const Offset(2.0, 2.0), // Sets shadow offset (optional)
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _maintenance.name,
                    style: const TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  if (_maintenance.description != null)
                    Text(_maintenance.description!),
                  if (_maintenance.dueDate != null)
                    Text(
                        'Due date: ${DateFormat('yyyy-MM-dd').format(_maintenance.dueDate!)}'),
                  if (_maintenance.dueDate != null)
                    Text('Mileage: ${_maintenance.dueMileage} km'),
                ],
              ),
              Column(
                children: [
                  Icon(
                    Icons.tire_repair,
                    color: primary,
                    size: 40.0,
                  )
                ],
              )
            ],
          ),
        )
        // ... other Container properties (width, height, child)
        );
  }
}
