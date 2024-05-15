import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_frontend/helpers/api_client.dart';
import 'package:flutter_frontend/helpers/api_endpoints.dart';
import 'package:flutter_frontend/models/car.dart';
import 'package:flutter_frontend/models/maintenance.dart';
import 'package:flutter_frontend/helpers/notification_service.dart';
import 'package:flutter_frontend/screens/forms/form_validator.dart';
import 'package:flutter_frontend/screens/forms/interval_picker.dart';
import 'package:form_validator/form_validator.dart';
import 'package:http/http.dart' as http;
import 'package:iso8601_duration/iso8601_duration.dart';

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
  final _descriptionFocusNode = FocusNode();
  late Maintenance _maintenance;
  late Car _car;
  late TextEditingController _dueDateController;
  late TextEditingController _dateIntervalController;
  var _isLoading = false;

  void _submit() {
    if (_formKey.currentState!.validate() && !_descriptionFocusNode.hasFocus) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      ApiClient.sendRequest(
              '${ApiEndpoints.carsEndpoint}/${_car.id}/maintenances/${_maintenance.id}',
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
    _car = widget.car;
    _dueDateController = TextEditingController(
        text: _maintenance.dueDate?.toString().split(" ")[0]);
    _dateIntervalController =
        TextEditingController(text: _maintenance.dateInterval.toString());
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
                constraints: const BoxConstraints(maxHeight: 700),
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
                          _maintenance.name =
                              value!.isNotEmpty ? value : _maintenance.name;
                        });
                      },
                    ),
                    TextFormField(
                      focusNode: _descriptionFocusNode,
                      initialValue: _maintenance.description,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      maxLines: 3,
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
                      validator: FormValidator.validateIntInput,
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onSaved: (value) {
                        setState(() {
                          _maintenance.dueMileage = int.tryParse(value!);
                        });
                      },
                    ),
                    TextFormField(
                      initialValue: _maintenance.mileageInterval?.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Mileage Interval',
                      ),
                      validator: FormValidator.validateIntInput,
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onSaved: (value) {
                        setState(() {
                          _maintenance.mileageInterval = int.tryParse(value!);
                        });
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Due Date',
                          filled: true,
                          prefixIcon: Icon(Icons.calendar_today)),
                      readOnly: true,
                      controller: _dueDateController,
                      onTap: () async {
                        var picked = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2101));
                        if (picked != null) {
                          setState(() {
                            _dueDateController.text =
                                picked.toString().split(" ")[0];
                          });
                        }
                      },
                      onSaved: (value) {
                        setState(() {
                          _maintenance.dueDate =
                              DateTime.tryParse(_dueDateController.text);
                        });
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Date Interval',
                          filled: true,
                          prefixIcon: Icon(Icons.cached)),
                      readOnly: true,
                      controller: _dateIntervalController,
                      onTap: () async {
                        var picked =
                            await IntervalPicker.showDateIntervalPicker(
                                context: context);
                        if (picked != null) {
                          final date = ISODurationConverter()
                              .parseString(isoDurationString: picked);
                          setState(() {
                            _dateIntervalController.text = date.toString();
                            _maintenance.dateInterval = date;
                          });
                        }
                      },
                    ),
                    TextFormField(
                      initialValue: _maintenance.cost?.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Cost',
                      ),
                      validator: FormValidator.validateFloatInput,
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onSaved: (value) {
                        setState(() {
                          _maintenance.cost =
                              value!.isNotEmpty ? value : _maintenance.cost;
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
                                : const Text("Edit"),
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
