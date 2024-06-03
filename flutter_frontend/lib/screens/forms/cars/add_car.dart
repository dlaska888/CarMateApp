import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_frontend/helpers/api_client.dart';
import 'package:flutter_frontend/helpers/api_endpoints.dart';
import 'package:flutter_frontend/models/car.dart';
import 'package:flutter_frontend/helpers/notification_service.dart';
import 'package:flutter_frontend/screens/forms/form_validator.dart';
import 'package:form_validator/form_validator.dart';
import 'package:http/http.dart' as http;

class AddCarForm extends StatefulWidget {
  final Function onSubmit;
  const AddCarForm(this.onSubmit, {super.key});

  @override
  AddCarFormState createState() => AddCarFormState();
}

class AddCarFormState extends State<AddCarForm> {
  final _formKey = GlobalKey<FormState>();
  final _car = Car(id: "", name: "");
  final productionDateController = TextEditingController();
  final purchaseDateController = TextEditingController();
  var _isLoading = false;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      ApiClient.sendRequest(ApiEndpoints.carsEndpoint,
              methodFun: http.post,
              body: _car.toJson(),
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
                          if (value!.isNotEmpty) _car.name = value;
                        });
                      },
                    ),
                    const SizedBox(),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Brand',
                      ),
                      validator: ValidationBuilder(optional: true)
                          .maxLength(255)
                          .build(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onSaved: (value) {
                        setState(() {
                          if (value!.isNotEmpty) _car.brand = value;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Model',
                      ),
                      validator: ValidationBuilder(optional: true)
                          .maxLength(255)
                          .build(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onSaved: (value) {
                        setState(() {
                          if (value!.isNotEmpty) _car.model = value;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Engine displacement',
                      ),
                      validator: FormValidator.validateFloatInput,
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onSaved: (value) {
                        setState(() {
                          _car.displacement = double.tryParse(value!);
                        });
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Production Date',
                          filled: true,
                          prefixIcon: Icon(Icons.calendar_today)),
                      readOnly: true,
                      controller: productionDateController,
                      onTap: () async {
                        var picked = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                            initialDatePickerMode: DatePickerMode.year);
                        if (picked != null) {
                          setState(() {
                            productionDateController.text =
                                picked.toString().split(" ")[0];
                          });
                        }
                      },
                      onSaved: (value) {
                        setState(() {
                          _car.productionDate =
                              DateTime.tryParse(productionDateController.text);
                        });
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'VIN',
                      ),
                      validator: ValidationBuilder(optional: true)
                          .minLength(17)
                          .maxLength(17)
                          .build(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onSaved: (value) {
                        setState(() {
                          if (value!.isNotEmpty) _car.vin = value;
                        });
                      },
                    ),
                    const SizedBox(),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Purchase Date',
                          filled: true,
                          prefixIcon: Icon(Icons.calendar_today)),
                      readOnly: true,
                      controller: purchaseDateController,
                      onTap: () async {
                        var picked = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                            initialDatePickerMode: DatePickerMode.year);
                        if (picked != null) {
                          setState(() {
                            purchaseDateController.text =
                                picked.toString().split(" ")[0];
                          });
                        }
                      },
                      onSaved: (value) {
                        setState(() {
                          _car.purchaseDate =
                              DateTime.tryParse(purchaseDateController.text);
                        });
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Mileage',
                      ),
                      validator: FormValidator.validateIntInput,
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onSaved: (value) {
                        setState(() {
                          _car.mileage = int.tryParse(value!);
                        });
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Plate',
                      ),
                      validator: ValidationBuilder(optional: true)
                          .minLength(6)
                          .maxLength(8)
                          .build(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onSaved: (value) {
                        setState(() {
                          if (value!.isNotEmpty) _car.plate = value;
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
                                : const Text("Add"),
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
