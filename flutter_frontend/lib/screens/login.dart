import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/api_client.dart';
import 'package:flutter_frontend/api_endpoints.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_validator/form_validator.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _toastMessage(context, String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Theme.of(context).primaryColorLight,
        textColor: Colors.white,
        fontSize: 16.0);
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
              height: MediaQuery.of(context).size.height / 2.25,
              padding: const EdgeInsets.all(48.0),
              decoration: BoxDecoration(
                color: primaryLight,
                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Login",
                      style: Theme.of(context).textTheme.displayLarge),
                  TextFormField(
                    controller: _email,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                    validator: ValidationBuilder().email().build(),
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: _password,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                    ),
                    validator: ValidationBuilder().required().build(),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ApiClient().sendRequest(ApiEndpoints.loginEndpoint, {
                          'username': _email.text,
                          'password': _password.text,
                        }).then((value) {
                          Navigator.pushNamed(context, '/dashboard');
                        }).catchError((error) {
                          _toastMessage(context, "Error: $error");
                        });
                      }
                    },
                    child: const Text("Login"),
                  ),
                  RichText(
                    text: TextSpan(
                      text: "Don't have an account? Sign up",
                      style:
                          const TextStyle(color: Colors.white, fontSize: 16.0),
                      recognizer: TapGestureRecognizer()
                        ..onTap =
                            () => Navigator.pushNamed(context, "/register"),
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
