import 'package:flutter/material.dart';
import 'package:flutter_frontend/api_client.dart';
import 'package:flutter_frontend/api_endpoints.dart';
import 'package:flutter_frontend/notification_service.dart';
import 'package:form_validator/form_validator.dart';
import 'package:http/http.dart' as http;

class AddCarForm extends StatefulWidget {
  const AddCarForm({super.key});

  @override
  AddCarFormState createState() => AddCarFormState();
}

class AddCarFormState extends State<AddCarForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _model = TextEditingController();
  final _brand = TextEditingController();
  final _displacement = TextEditingController();
  final _productionDate = TextEditingController();
  final _mileage = TextEditingController();
  final _purchaseDate = TextEditingController();
  final _plate = TextEditingController();
  final _vin = TextEditingController();
  var _isLoading = false;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      ApiClient.sendRequest(ApiEndpoints.carsEndpoint,
          methodFun: http.post,
            body: {
            if (_name.text.isNotEmpty) 'name': _name.text,
            if (_model.text.isNotEmpty) 'model': _model.text,
            if (_brand.text.isNotEmpty) 'brand': _brand.text,
            if (_displacement.text.isNotEmpty) 'displacement': _displacement.text,
            if (_productionDate.text.isNotEmpty) 'productionDate': _productionDate.text,
            if (_mileage.text.isNotEmpty) 'mileage': _mileage.text,
            if (_purchaseDate.text.isNotEmpty) 'purchaseDate': _purchaseDate.text,
            if (_plate.text.isNotEmpty) 'plate': _plate.text,
            if (_vin.text.isNotEmpty) 'vin': _vin.text,
            }).then((value) => Navigator.pop(context)).catchError((error) {
        NotificationService.showNotification("Error: $error",
            type: MessageType.error);
      }).whenComplete(() {
        setState(() {
          _isLoading = false;
        });
      });
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
      double displacement = double.parse(value);
      if (displacement <= 0) {
        return 'Displacement must be a positive number';
      }
      return null;
    } catch (e) {
      return 'Invalid Displacement format';
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
                    controller: _model,
                    decoration: const InputDecoration(
                      hintText: 'Model',
                    ),
                    validator: ValidationBuilder(optional: true)
                        .maxLength(255)
                        .build(),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  TextFormField(
                    controller: _brand,
                    decoration: const InputDecoration(
                      hintText: 'Brand',
                    ),
                    validator: ValidationBuilder(optional: true)
                        .maxLength(255)
                        .build(),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  TextFormField(
                    controller: _displacement,
                    decoration: const InputDecoration(
                      hintText: 'Displacement',
                    ),
                    validator: _selectFloat,
                    keyboardType: TextInputType.number,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  TextFormField(
                    controller: _productionDate,
                    decoration: const InputDecoration(
                        labelText: 'Production Date',
                        filled: true,
                        prefixIcon: Icon(Icons.calendar_today)),
                    readOnly: true,
                    onTap: () {
                      _selectDate(_productionDate);
                    },
                  ),
                  TextFormField(
                    controller: _mileage,
                    decoration: const InputDecoration(
                      hintText: 'Mileage',
                    ),
                    validator: _selectFloat,
                    keyboardType: TextInputType.number,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  TextFormField(
                    controller: _purchaseDate,
                    decoration: const InputDecoration(
                        labelText: 'Purchase Date',
                        filled: true,
                        prefixIcon: Icon(Icons.calendar_today)),
                    readOnly: true,
                    onTap: () {
                      _selectDate(_purchaseDate);
                    },
                  ),
                  TextFormField(
                    controller: _plate,
                    decoration: const InputDecoration(
                      hintText: 'Plate',
                    ),
                    validator: ValidationBuilder(optional: true)
                        .minLength(6)
                        .maxLength(8)
                        .build(),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  TextFormField(
                    controller: _vin,
                    decoration: const InputDecoration(
                      hintText: 'VIN',
                    ),
                    validator: ValidationBuilder(optional: true)
                        .minLength(17)
                        .maxLength(17)
                        .build(),
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
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : const Text("Add Car"),
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
    );
  }
}
