import 'package:flutter/material.dart';
import 'package:flutter_frontend/api_client.dart';
import 'package:flutter_frontend/api_endpoints.dart';
import 'package:flutter_frontend/models/car.dart';
import 'package:flutter_frontend/models/maintenance.dart';
import 'package:flutter_frontend/notification_service.dart';
import 'package:flutter_frontend/screens/dashboard_pages/home_components/maintenance_info.dart';
import 'package:flutter_frontend/screens/forms/form_modal.dart';
import 'package:flutter_frontend/screens/forms/maintenances/delete_maintenance.dart';
import 'package:flutter_frontend/screens/forms/maintenances/edit_maintenance.dart';
import 'package:intl/intl.dart';

class MaintenanceCard extends StatefulWidget {
  final Maintenance maintenance;
  final Car car;
  const MaintenanceCard(this.maintenance, this.car, {super.key});

  @override
  State<MaintenanceCard> createState() => _MaintenanceCardState();
}

class _MaintenanceCardState extends State<MaintenanceCard> {
  late Maintenance _maintenance;
  late Car _car;
  bool isMaintenanceDeleted = false;

  Future<Maintenance> fetchCar() async {
    return ApiClient.sendRequest(
            '${ApiEndpoints.carsEndpoint}/${_car.id}/maintenances/${_maintenance.id}',
            authorizedRequest: true)
        .then((data) {
      return Maintenance.fromJson(data);
    }).catchError((error) {
      NotificationService.showNotification("$error", type: MessageType.error);
      throw error;
    });
  }

  void refreshMaintenance() {
    fetchCar().then((maintenance) {
      setState(() {
        _maintenance = maintenance;
      });
    });
  }

  void removeMaintenance() {
    setState(() {
      isMaintenanceDeleted = true;
    });
  }

  @override
  void initState() {
    _maintenance = widget.maintenance;
    _car = widget.car;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    if (isMaintenanceDeleted) {
      return const SizedBox();
    }

    return GestureDetector(
      onTap: () => FormModal(context).showModal(MaintenanceInfo(_maintenance)),
      child: Container(
        margin: const EdgeInsets.all(8.0),
        child: Dismissible(
          key: Key(_maintenance.id),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.startToEnd) {
              FormModal(context).showModal(
                  DeleteMaintenanceForm(_maintenance, _car, removeMaintenance));
            } else if (direction == DismissDirection.endToStart) {
              FormModal(context).showModal(
                  EditMaintenanceForm(_maintenance, _car, refreshMaintenance));
            }
            return false;
          },
          background: Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 24.0),
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          secondaryBackground: Expanded(
            child: Container(
              padding: const EdgeInsets.only(right: 24.0),
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2.0,
                    blurRadius: 4.0,
                    offset: const Offset(2.0, 2.0),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _maintenance.name,
                            style: const TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                          if (_maintenance.dueDate != null)
                            Text(
                                'Due date: ${DateFormat('d MMMM yyyy').format(_maintenance.dueDate!)}'),
                          if (_maintenance.dueMileage != null)
                            Text('Due mileage: ${_maintenance.dueMileage} km'),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Icon(
                          Icons.build_outlined,
                          color: primary,
                          size: 40.0,
                        )
                      ],
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
