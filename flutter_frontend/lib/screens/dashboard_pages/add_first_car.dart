import 'package:flutter/material.dart';
import 'package:flutter_frontend/screens/forms/cars/add_car.dart';
import 'package:flutter_frontend/screens/forms/form_modal.dart';

class AddFirstCarPage extends StatefulWidget {
  final Function onCarAdded;
  const AddFirstCarPage(this.onCarAdded, {super.key});

  @override
  State<AddFirstCarPage> createState() => _AddFirstCarPageState();
}

class _AddFirstCarPageState extends State<AddFirstCarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ElevatedButton(
        onPressed: () {
          FormModal(context).showModal(AddCarForm(widget.onCarAdded));
        },
        child: const Text('Add first car'),
      ),
    ));
  }
}
