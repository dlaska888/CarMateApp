import 'package:flutter/material.dart';
import 'package:flutter_frontend/screens/forms/add_car.dart';
import 'package:flutter_frontend/screens/forms/add_maintenance.dart';

class DashBoardButton extends StatelessWidget {
  final int _selectedPage;

  const DashBoardButton(int selectedPage, {super.key}) :
    _selectedPage = selectedPage;
  

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final primary = Theme.of(context).primaryColor;
    StatefulWidget form;

    if (_selectedPage == 0) {
      form = const AddMaintenanceForm();
    } else if (_selectedPage == 1) {
      form = const AddCarForm();
    } else {
      return const SizedBox.shrink();
    }

    return FloatingActionButton(
      backgroundColor: primary,
      onPressed: () {
        screenWidth < 768
            ? showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return form;
                })
            : showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: form,
                  );
                });
      },
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
