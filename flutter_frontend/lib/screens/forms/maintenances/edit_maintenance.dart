import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_frontend/api_client.dart';
import 'package:flutter_frontend/api_endpoints.dart';
import 'package:flutter_frontend/models/car.dart';
import 'package:flutter_frontend/models/maintenance.dart';
import 'package:flutter_frontend/notification_service.dart';
import 'package:flutter_frontend/screens/forms/form_helper.dart';
import 'package:form_validator/form_validator.dart';
import 'package:http/http.dart' as http;

class EditMaintenanceForm extends StatefulWidget {
  final Maintenance maintenance;
  final Car car;
  final Function onSubmit;
  const EditMaintenanceForm(this.maintenance, this.car, this.onSubmit,
      {super.key});

  @override
  EditMaintenanceFormState createState() => EditMaintenanceFormState();
}

class EditMaintenanceFormState extends State<EditMaintenanceForm> {
  final _formKey = GlobalKey<FormState>();
  late Maintenance _maintenance;
  late TextEditingController dueDateController;
  var _isLoading = false;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      ApiClient.sendRequest(
              '${ApiEndpoints.carsEndpoint}/maintenances/${_maintenance.id}',
              methodFun: http.put,
              body: _maintenance.toJson(),
              authorizedRequest: true)
          .then((_) {
        widget.onSubmit();
        Navigator.pop(context);
      }).catchError((error) {
        NotificationService.showNotification("Error: $error",
            type: MessageType.error);
      }).whenComplete(() {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _maintenance = widget.maintenance;
    dueDateController = TextEditingController(
        text: _maintenance.dueDate?.toString().split(" ")[0]);
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKeyEvent: (event) {
        if (event.logicalKey == LogicalKeyboardKey.enter) {
          _submit();
        } else if (event.logicalKey == LogicalKeyboardKey.escape) {
          Navigator.pop(context);
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
              key: _formKey,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 800),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextFormField(
                      initialValue: _maintenance.name,
                      decoration: const InputDecoration(
                        labelText: 'Name *',
                      ),
                      validator: ValidationBuilder()
                          .required()
                          .minLength(2)
                          .maxLength(50)
                          .build(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onSaved: (value) {
                        setState(() {
                          _maintenance.name = value!.isNotEmpty
                              ? value
                              : _maintenance.name;
                        });
                      },
                    ),
                    const SizedBox(),
                    TextFormField(
                      initialValue: _maintenance.description,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      validator: ValidationBuilder(optional: true)
                          .maxLength(255)
                          .build(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onSaved: (value) {
                        setState(() {
                          _maintenance.description =
                              value!.isNotEmpty ? value : null;
                        });
                      },
                    ),
                    TextFormField(
                      initialValue: _maintenance.dueMileage?.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Due Mileage',
                      ),
                      validator: FormHelper.validateIntInput,
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onSaved: (value) {
                        setState(() {
                          _maintenance.dueMileage = int.tryParse(value!);
                        });
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Due Date',
                          filled: true,
                          prefixIcon: Icon(Icons.calendar_today)),
                      readOnly: true,
                      controller: dueDateController,
                      onTap: () async {
                        var picked = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                            initialDatePickerMode: DatePickerMode.year);
                        if (picked != null) {
                          setState(() {
                            dueDateController.text =
                                picked.toString().split(" ")[0];
                          });
                        }
                      },
                      onSaved: (value) {
                        setState(() {
                          _maintenance.dueDate =
                              DateTime.tryParse(dueDateController.text);
                        });
                      },
                    ),
                    TextFormField(
                      initialValue: _maintenance.cost?.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Cost',
                      ),
                      validator: FormHelper.validateFloatInput,
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onSaved: (value) {
                        setState(() {
                          _maintenance.cost = value!.isNotEmpty
                              ? value
                              : _maintenance.cost;
                        });
                      },
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
                            child: _isLoading
                                ? const CircularProgressIndicator()
                                : const Text("Edit Maintenance"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
