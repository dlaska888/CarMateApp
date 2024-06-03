import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_frontend/helpers/api_client.dart';
import 'package:flutter_frontend/helpers/api_endpoints.dart';
import 'package:flutter_frontend/models/car.dart';
import 'package:flutter_frontend/models/maintenance.dart';
import 'package:flutter_frontend/helpers/notification_service.dart';
import 'package:http/http.dart' as http;

class DeleteMaintenanceForm extends StatefulWidget {
  final Maintenance maintenance;
  final Car car;
  final Function onSubmit;
  const DeleteMaintenanceForm(this.maintenance, this.car, this.onSubmit,
      {super.key});

  @override
  DeleteMaintenanceFormState createState() => DeleteMaintenanceFormState();
}

class DeleteMaintenanceFormState extends State<DeleteMaintenanceForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      ApiClient.sendRequest(
              '${ApiEndpoints.carsEndpoint}/${widget.car.id}/maintenances/${widget.maintenance.id}',
              methodFun: http.delete,
              authorizedRequest: true)
          .then((_) {
        NotificationService.showNotification("Maintenance deleted successfully",
            type: MessageType.ok);
        widget.onSubmit();
      }).catchError((error) {
        NotificationService.showNotification("$error", type: MessageType.error);
      }).whenComplete(() {
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
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
                constraints: const BoxConstraints(maxHeight: 200),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Are you sure?",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
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
                                : const Text("Delete"),
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
