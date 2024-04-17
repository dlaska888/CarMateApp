import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

class AddMaintenanceForm extends StatefulWidget {
  const AddMaintenanceForm({Key? key});

  @override
  AddMaintenanceFormState createState() => AddMaintenanceFormState();
}

class AddMaintenanceFormState extends State<AddMaintenanceForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _dueMileage = TextEditingController();
  final _dueDate = TextEditingController();
  final _cost = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement the logic to add a maintenance
    }
  }

  Future<void> _selectDate(TextEditingController controller) async {
    var picked = await showDatePicker(
        context: context, firstDate: DateTime.now(), lastDate: DateTime(2100));

    if (picked != null) {
      setState(() {
        controller.text = picked.toString().split(" ")[0];
      });
    }
  }

  String? _selectFloat(value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    try {
      double floatValue = double.parse(value);
      if (floatValue <= 0) {
        return 'Value must be a positive number';
      }
      return null;
    } catch (e) {
      return 'Invalid format';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 800),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextFormField(
                    controller: _name,
                    decoration: const InputDecoration(
                      hintText: 'Name',
                    ),
                    validator: ValidationBuilder()
                        .required()
                        .minLength(2)
                        .maxLength(50)
                        .build(),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  TextFormField(
                    controller: _description,
                    decoration: const InputDecoration(
                      hintText: 'Description',
                    ),
                    validator:
                        ValidationBuilder(optional: true).maxLength(255).build(),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  TextFormField(
                    controller: _dueMileage,
                    decoration: const InputDecoration(
                      hintText: 'Due Mileage',
                    ),
                    validator: _selectFloat,
                    keyboardType: TextInputType.number,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  TextFormField(
                    controller: _dueDate,
                    decoration: const InputDecoration(
                        labelText: 'Due Date',
                        filled: true,
                        prefixIcon: Icon(Icons.calendar_today)),
                    readOnly: true,
                    onTap: () {
                      _selectDate(_dueDate);
                    },
                  ),
                  TextFormField(
                    controller: _cost,
                    decoration: const InputDecoration(
                      hintText: 'Cost',
                    ),
                    validator: _selectFloat,
                    keyboardType: TextInputType.number,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: _submit,
                          child: const Text("Add Maintenance"),
                        )
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