import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/api_client.dart';
import 'package:flutter_frontend/api_endpoints.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_validator/form_validator.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _cpassword = TextEditingController();
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
              height: MediaQuery.of(context).size.height / 1.75,
              padding: const EdgeInsets.all(48.0),
              decoration: BoxDecoration(
                color: primaryLight,
                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              ),
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
                    validator: ValidationBuilder().minLength(3).build(),
                  ),
                  TextFormField(
                    controller: _email,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                    validator: ValidationBuilder().email().build(),
                  ),
                  TextFormField(
                    controller: _password,
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
                    controller: _cpassword,
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ApiClient().sendRequest(ApiEndpoints.registerEndpoint, {
                          'username': _username.text,
                          'email': _email.text,
                          'password': _password.text,
                          'passwordConfirm': _cpassword.text,
                        }).then((value) {
                          Navigator.pushNamed(context, '/dashboard');
                        }).catchError((error) {
                          _toastMessage(context, "Error: $error");
                        });
                      }
                    },
                    child: const Text("Register"),
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
