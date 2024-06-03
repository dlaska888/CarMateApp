import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_frontend/helpers/api_client.dart';
import 'package:flutter_frontend/helpers/api_endpoints.dart';
import 'package:flutter_frontend/helpers/notification_service.dart';
import 'package:flutter_frontend/screens/forms/common_validators.dart';
import 'package:form_validator/form_validator.dart';
import 'package:http/http.dart' as http;

class ChangeUsernameForm extends StatefulWidget {
  final Function onSubmit;
  const ChangeUsernameForm(this.onSubmit, {super.key});

  @override
  State<ChangeUsernameForm> createState() => _ChangeUsernameFormState();
}

class _ChangeUsernameFormState extends State<ChangeUsernameForm> {
  final _formKey = GlobalKey<FormState>();
  final _newUsernameController = TextEditingController();
  final _passwordController = TextEditingController();
  var _isLoading = false;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      ApiClient.sendRequest("${ApiEndpoints.accountEndpoint}/change-username",
              methodFun: http.post,
              body: {
                "username": _newUsernameController.text,
                "password": _passwordController.text,
              },
              authorizedRequest: true)
          .then((_) {
        widget.onSubmit();
        NotificationService.showNotification("Username changed successfully");
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
                constraints: const BoxConstraints(maxHeight: 300),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'New Username',
                      ),
                      validator: CommonValidators.getUsernameValidator(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onSaved: (value) {
                        setState(() {
                          _newUsernameController.text = value!;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                      obscureText: true,
                      validator: ValidationBuilder()
                          .required()
                          .minLength(6)
                          .maxLength(128)
                          .build(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onSaved: (value) {
                        setState(() {
                          _passwordController.text = value!;
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
                                : const Text("Change"),
                          ),
                        ],
                      ),
                    )
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
