import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_frontend/models/car.dart';

class CarInfo extends StatelessWidget {
  final Car _car;
  const CarInfo(this._car, {super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKeyEvent: (event) {
        if (event.logicalKey == LogicalKeyboardKey.escape) {
          Navigator.of(context).pop();
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                  ConstrainedBox(
                    constraints:
                        const BoxConstraints(maxHeight: 600, maxWidth: 500),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextFormField(
                          initialValue: _car.name,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                          ),
                          readOnly: true,
                        ),
                        TextFormField(
                          initialValue: _car.brand ?? 'Not provided',
                          decoration: const InputDecoration(
                            labelText: 'Brand',
                          ),
                          readOnly: true,
                        ),
                        TextFormField(
                          initialValue: _car.model ?? 'Not provided',
                          decoration: const InputDecoration(
                            labelText: 'Model',
                          ),
                          readOnly: true,
                        ),
                        TextFormField(
                          initialValue: _car.displacement?.toStringAsFixed(1) ?? 'Not provided',
                          decoration: const InputDecoration(
                            labelText: 'Engine displacement',
                          ),
                          readOnly: true,
                        ),
                        TextFormField(
                          initialValue:
                              _car.productionDate != null ? _car.productionDate.toString().split(" ")[0] : 'Not provided',
                          decoration: const InputDecoration(
                              labelText: 'Production Date',
                              filled: true,
                              prefixIcon: Icon(Icons.calendar_today)),
                          readOnly: true,
                        ),
                        TextFormField(
                          initialValue: _car.vin ?? 'Not provided',
                          decoration: const InputDecoration(
                            labelText: 'VIN',
                          ),
                          readOnly: true,
                        ),
                        TextFormField(
                          initialValue:
                              _car.purchaseDate != null ? _car.purchaseDate.toString().split(" ")[0] : 'Not provided',
                          decoration: const InputDecoration(
                              labelText: 'Purchase Date',
                              filled: true,
                              prefixIcon: Icon(Icons.calendar_today)),
                          readOnly: true,
                        ),
                        TextFormField(
                          initialValue: _car.mileage?.toString() ?? 'Not provided',
                          decoration: const InputDecoration(
                            labelText: 'Mileage',
                          ),
                          readOnly: true,
                        ),
                        TextFormField(
                          initialValue: _car.plate ?? 'Not provided',
                          decoration: const InputDecoration(
                            labelText: 'Plate',
                          ),
                          readOnly: true,
                        ),
                        const SizedBox()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
