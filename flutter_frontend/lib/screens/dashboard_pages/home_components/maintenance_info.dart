import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_frontend/models/maintenance.dart';

class MaintenanceInfo extends StatelessWidget {
  final Maintenance _maintenance;
  const MaintenanceInfo(this._maintenance, {super.key});

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
                        const BoxConstraints(maxHeight: 400, maxWidth: 500),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextFormField(
                          initialValue: _maintenance.name,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                          ),
                          readOnly: true,
                        ),
                        TextFormField(
                          initialValue: _maintenance.description ?? 'Not provided',
                          decoration: const InputDecoration(
                            labelText: 'Description',
                          ),
                          readOnly: true,
                          maxLines: 3,
                        ),
                        TextFormField(
                          initialValue: _maintenance.dueMileage?.toString() ?? 'Not provided',
                          decoration: const InputDecoration(
                            labelText: 'Due Mileage',
                          ),
                          readOnly: true,
                        ),
                        TextFormField(
                          initialValue:
                              _maintenance.dueDate != null ? _maintenance.dueDate.toString().split(" ")[0] : 'Not provided',
                          decoration: const InputDecoration(
                              labelText: 'Due Date',
                              filled: true,
                              prefixIcon: Icon(Icons.calendar_today)),
                          readOnly: true,
                        ),
                        TextFormField(
                          initialValue: _maintenance.cost ?? 'Not provided',
                          decoration: const InputDecoration(
                            labelText: 'Cost',
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
