import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_frontend/helpers/api_client.dart';
import 'package:flutter_frontend/helpers/api_endpoints.dart';
import 'package:flutter_frontend/helpers/notification_service.dart';
import 'package:flutter_frontend/screens/forms/common_validators.dart';
import 'package:form_validator/form_validator.dart';
import 'package:http/http.dart' as http;

class ChangePasswordForm extends StatefulWidget {
  final Function onSubmit;
  const ChangePasswordForm(this.onSubmit, {super.key});

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  var _isLoading = false;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      ApiClient.sendRequest("${ApiEndpoints.accountEndpoint}/change-password",
              methodFun: http.post,
              body: {
                "password": _passwordController.text,
                "newPassword": _newPasswordController.text,
                "newPasswordConfirm": _confirmPasswordController.text
              },
              authorizedRequest: true)
          .then((_) {
        widget.onSubmit();
        NotificationService.showNotification("Password changed successfully");
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
                constraints: const BoxConstraints(maxHeight: 400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'New Password',
                      ),
                      obscureText: true,
                      validator: CommonValidators.getPasswordValidator(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (value) {
                        setState(() {
                          _newPasswordController.text = value;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value != _newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (value) {
                        setState(() {
                          _confirmPasswordController.text = value;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Current Password',
                      ),
                      obscureText: true,
                      validator: ValidationBuilder()
                          .required()
                          .minLength(6)
                          .maxLength(128)
                          .build(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (value) {
                        setState(() {
                          _passwordController.text = value;
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
