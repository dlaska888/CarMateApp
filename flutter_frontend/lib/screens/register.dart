import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/api_client.dart';
import 'package:flutter_frontend/api_endpoints.dart';
import 'package:flutter_frontend/notification_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:form_validator/form_validator.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _secureStorage = const FlutterSecureStorage();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _cpassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      ApiClient.sendRequest(ApiEndpoints.registerEndpoint,
          methodFun: http.post,
          body: {
            'username': _username.text,
            'email': _email.text,
            'password': _password.text,
            'passwordConfirm': _cpassword.text,
          }).then((data) {
        _secureStorage.write(key: 'jwt', value: data['token']);
        Navigator.pushNamed(context, '/dashboard');
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
    Color primary = Theme.of(context).primaryColor;
    Color primaryLight = Theme.of(context).primaryColorLight;

    return Scaffold(
      backgroundColor: primary,
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(48.0),
              decoration: BoxDecoration(
                color: primaryLight,
                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              ),
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height / 1.5),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Register",
                      style: Theme.of(context).textTheme.displayLarge),
                  TextFormField(
                    controller: _username,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      hintText: 'Username',
                    ),
                    validator: ValidationBuilder()
                        .minLength(3)
                        .regExp(RegExp('^[a-zA-Z0-9_]+\$'),
                            'Only letters, numbers and underscores are allowed')
                        .build(),
                  ),
                  TextFormField(
                    autofillHints: const [AutofillHints.newUsername],
                    controller: _email,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                    validator: ValidationBuilder().email().build(),
                  ),
                  TextFormField(
                    autofillHints: const [AutofillHints.newPassword],
                    controller: _password,
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                    ),
                    validator: ValidationBuilder()
                        .minLength(8)
                        .regExp(RegExp(r'^(?=.*?[A-Z])'),
                            'Password must contain at least one uppercase letter')
                        .regExp(RegExp(r'^(?=.*?[a-z])'),
                            'Password must contain at least one lowercase letter')
                        .regExp(RegExp(r'^(?=.*?[0-9])'),
                            'Password must contain at least one number')
                        .regExp(
                            RegExp(r'^(?=.*?[!@#$%^&*()_\-+={}[\]|;:"<>,./?])'),
                            'Password must contain at least one special character')
                        .build(),
                  ),
                  TextFormField(
                    autofillHints: const [AutofillHints.password],
                    controller: _cpassword,
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      hintText: 'Password confirm',
                    ),
                    validator: (value) {
                      return value!.isEmpty || value != _password.text
                          ? 'Passwords do not match'
                          : null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: _submit,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text("Register"),
                  ),
                  RichText(
                    text: TextSpan(
                      text: "Already have an account? Sign in",
                      style:
                          const TextStyle(color: Colors.white, fontSize: 16.0),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.pushNamed(context, "/login"),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.directions_car,
                    color: Colors.white,
                    size: 48.0,
                  ),
                  Text("CarMate",
                      style: TextStyle(color: Colors.white, fontSize: 24.0)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
