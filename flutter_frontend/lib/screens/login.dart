import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_frontend/helpers/api_client.dart';
import 'package:flutter_frontend/helpers/api_endpoints.dart';
import 'package:flutter_frontend/helpers/notification_service.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      ApiClient.sendRequest(ApiEndpoints.loginEndpoint,
              methodFun: http.post,
              body: {
            'username': _email.text,
            'password': _password.text,
          })
          .then((data) async {
            await ApiClient.login(data['token'], data['refresh_token']);
          })
          .then((value) => context.go('/dashboard'))
          .catchError((error) {
            NotificationService.showNotification("Error: $error",
                type: MessageType.error);
          })
          .whenComplete(() {
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

    return KeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKeyEvent: (event) {
        if (event.logicalKey == LogicalKeyboardKey.enter) {
          _submit();
        }
      },
      child: Scaffold(
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
                    minHeight: MediaQuery.of(context).size.height / 2),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Login",
                        style: Theme.of(context).textTheme.displayLarge),
                    TextFormField(
                      autofillHints: const [AutofillHints.username],
                      controller: _email,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                      ),
                      validator: ValidationBuilder().email().build(),
                    ),
                    TextFormField(
                      autofillHints: const [AutofillHints.password],
                      controller: _password,
                      obscureText: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                      ),
                      validator: ValidationBuilder().required().build(),
                    ),
                    ElevatedButton(
                      onPressed: _submit,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text("Login"),
                    ),
                    RichText(
                      text: TextSpan(
                          text: "Don't have an account? Sign up",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16.0),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => context.go('/register')),
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
      ),
    );
  }
}
